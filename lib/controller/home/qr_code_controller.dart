import 'dart:convert';

import 'package:car_ticket/domain/models/ticket/ticket.dart';
import 'package:car_ticket/domain/repositories/payment_repository/payment_repository_imp.dart';
import 'package:car_ticket/domain/repositories/shared/shared_preference_repository.dart';
import 'package:car_ticket/presentation/screens/main_screen/home/ticket_verification_result_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class QRcodeController extends GetxController {
  final PaymentRepositoryImpl paymentRepository =
      Get.put(PaymentRepositoryImpl());
  final TicketAppSharedPreferenceRepository sharedPreferenceRepository =
      TicketAppSharedPreferenceRepository();
  GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isVerifying = false;
  bool isValid = false;
  String scanMessage = '';
  bool completingCheckingTicket = false;

  List<ExcelTicket> ticketsList = [];
  ExcelTicket selectedTicket = ExcelTicket.empty;

  setSelectedTicket(ExcelTicket ticket) async {
    selectedTicket = ticket;
    await completeCheckingTicket(ticket);
    update();
  }

  completeCheckingTicket(ExcelTicket ticket) async {
    try {} catch (e) {
      isVerifying = false;
      update();
      rethrow;
    }
  }

  Future<void> verifyQrCode(String qrData) async {
    try {
      isVerifying = true;
      completingCheckingTicket = true;
      update();

      // Default to invalid until proven otherwise
      isValid = false;
      scanMessage = 'Invalid QR Code';

      // Parse the QR data
      final Map<String, dynamic> parsedData = jsonDecode(qrData);

      // Check if it's a ticket QR code
      if (parsedData['type'] == 'ticket') {
        // Get ticket details
        final String ticketId = parsedData['ticketId'] ?? '';
        final String ticketNumber = parsedData['ticketNumber'] ?? '';

        if (ticketId.isEmpty) {
          scanMessage = 'Invalid ticket data';
          isValid = false;
        } else {
          // Check ticket in database
          await Future.delayed(
              const Duration(seconds: 1)); // Simulate network request

          final ticketDoc = await FirebaseFirestore.instance
              .collection('tickets')
              .doc(ticketId)
              .get();

          if (!ticketDoc.exists) {
            scanMessage = 'Ticket not found';
            isValid = false;
          } else {
            final ticketData = ticketDoc.data()!;

            // Check if ticket is expired
            final DateTime expiryDate =
                (ticketData['expiryDate'] as Timestamp).toDate();
            if (DateTime.now().isAfter(expiryDate)) {
              scanMessage =
                  'Ticket expired on ${DateFormat('MMM dd, yyyy').format(expiryDate)}';
              isValid = false;
            }
            // Check if ticket is already used
            else if (ticketData['isUsed'] == true) {
              scanMessage =
                  'Ticket already used on ${DateFormat('MMM dd, yyyy hh:mm a').format((ticketData['usedAt'] as Timestamp).toDate())}';
              isValid = false;
            }
            // Valid ticket
            else {
              // Mark ticket as used
              await FirebaseFirestore.instance
                  .collection('tickets')
                  .doc(ticketId)
                  .update({
                'isUsed': true,
                'usedAt': FieldValue.serverTimestamp(),
              });

              scanMessage = 'Valid ticket: ${ticketData['passengerName']}';
              isValid = true;
            }
          }
        }
      }
      // Check if it's a vehicle entry QR code
      else if (parsedData['type'] == 'vehicle_entry') {
        final String carId = parsedData['id'] ?? '';
        final String plateNumber = parsedData['plateNumber'] ?? '';

        if (carId.isEmpty || plateNumber.isEmpty) {
          scanMessage = 'Invalid vehicle data';
          isValid = false;
        } else {
          // Verify the car exists
          await Future.delayed(
              const Duration(seconds: 1)); // Simulate network request

          final carDoc = await FirebaseFirestore.instance
              .collection('cars')
              .doc(carId)
              .get();

          if (!carDoc.exists) {
            scanMessage = 'Vehicle not found';
            isValid = false;
          } else {
            final carData = carDoc.data()!;

            if (carData['plateNumber'] != plateNumber) {
              scanMessage = 'Vehicle plate number mismatch';
              isValid = false;
            } else {
              // Get destination data if available
              final destinations = await FirebaseFirestore.instance
                  .collection('destinations')
                  .where('carId', isEqualTo: carId)
                  .where('isAssigned', isEqualTo: true)
                  .get();

              String route = '';
              if (destinations.docs.isNotEmpty) {
                final destData = destinations.docs.first.data();
                route = '${destData['from']} → ${destData['to']}';
              }

              scanMessage =
                  'Valid vehicle: ${carData['name']} (${carData['plateNumber']})${route.isNotEmpty ? '\nRoute: $route' : ''}';
              isValid = true;
            }
          }
        }
      } else {
        scanMessage = 'Unknown QR code type';
        isValid = false;
      }
    } catch (e) {
      print('QR verification error: $e');
      scanMessage = 'Error processing QR code: ${e.toString()}';
      isValid = false;
    } finally {
      isVerifying = false;
      completingCheckingTicket = false;
      update();

      // Navigate to result screen
      Get.to(() => TicketVerificationResultScreen(
            isValid: isValid,
            message: scanMessage,
          ));
    }
  }
}
