import 'package:car_ticket/domain/models/payment/customer_payment.dart';
import 'package:car_ticket/domain/models/user/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ReportController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoadingEarnings = false;
  bool isLoadingMembers = false;

  List<Map<String, dynamic>> earningsData = [];
  List<MyUser> membersData = [];
  List<Map<String, dynamic>> dailyEarnings = [];
  List<Map<String, dynamic>> cancelledTicketsData = [];
  int totalCancelledTickets = 0;
  double totalCancelledAmount = 0;

  int totalBookings = 0;
  double totalRevenue = 0;
  double averageBookingValue = 0;

  // Get earnings report data
  Future<void> getEarningsReportData(
      DateTime startDate, DateTime endDate) async {
    try {
      isLoadingEarnings = true;
      update();

      // Clear previous data
      earningsData = [];
      dailyEarnings = [];
      totalBookings = 0;
      totalRevenue = 0;

      // Normalize dates to start of day and end of day
      final startDateTime =
          DateTime(startDate.year, startDate.month, startDate.day);
      final endDateTime =
          DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

      // Convert to strings for Firestore query
      final startDateStr = DateFormat('yyyy-MM-dd').format(startDateTime);
      final endDateStr = DateFormat('yyyy-MM-dd').format(endDateTime);

      // Fetch payments between the date range - FIXED QUERY
      final paymentQuery = await _firestore
          .collection('payments')
          .where('paymentStatus', whereIn: [
        'completed',
        'succeeded'
      ]) // Only count completed payments
          .get();

      // Process payment data and filter by date range in memory (since Firestore might store dates in different formats)
      final allPayments = paymentQuery.docs
          .map((doc) => UserPayment.fromDocument(doc.data()))
          .toList();

      // Filter payments by date manually to ensure correct date handling
      final payments = allPayments.where((payment) {
        try {
          DateTime paymentDate = DateTime.parse(payment.paymentDate);
          return paymentDate
                  .isAfter(startDateTime.subtract(const Duration(days: 1))) &&
              paymentDate.isBefore(endDateTime.add(const Duration(days: 1)));
        } catch (e) {
          print(
              'Error parsing date for payment: ${payment.id} - ${e.toString()}');
          return false;
        }
      }).toList();

      // Group payments by date
      final Map<String, List<UserPayment>> paymentsByDate = {};
      for (var payment in payments) {
        String dateStr;
        try {
          final DateTime paymentDate = DateTime.parse(payment.paymentDate);
          dateStr = DateFormat('yyyy-MM-dd').format(paymentDate);
        } catch (e) {
          dateStr = payment.paymentDate;
        }

        if (!paymentsByDate.containsKey(dateStr)) {
          paymentsByDate[dateStr] = [];
        }
        paymentsByDate[dateStr]!.add(payment);
      }

      // Calculate daily stats
      for (var date in paymentsByDate.keys) {
        final paymentsForDay = paymentsByDate[date]!;
        final count = paymentsForDay.length;
        double revenue = 0;

        for (var payment in paymentsForDay) {
          try {
            revenue += double.parse(payment.paymentAmount);
          } catch (e) {
            print(
                'Error parsing amount: ${payment.paymentAmount} - ${e.toString()}');
          }
        }

        final avgValue = count > 0 ? revenue / count : 0;

        dailyEarnings.add({
          'date': date,
          'count': count,
          'revenue': revenue,
          'averageValue': avgValue,
        });

        totalBookings += count;
        totalRevenue += revenue;
      }

      // Sort by date
      dailyEarnings.sort((a, b) {
        try {
          final dateA = DateFormat('yyyy-MM-dd').parse(a['date'] as String);
          final dateB = DateFormat('yyyy-MM-dd').parse(b['date'] as String);
          return dateA.compareTo(dateB);
        } catch (e) {
          return 0;
        }
      });

      // Calculate global average
      averageBookingValue =
          totalBookings > 0 ? totalRevenue / totalBookings : 0;

      // Format for display in reports
      for (var daily in dailyEarnings) {
        earningsData.add({
          'date': _formatReportDate(daily['date'] as String),
          'bookings': daily['count'].toString(),
          'revenue': 'RWF ${NumberFormat("#,###").format(daily['revenue'])}',
          'averageValue':
              'RWF ${NumberFormat("#,###").format(daily['averageValue'])}'
        });
      }

      // Add debug print to verify data
      print('Loaded ${earningsData.length} days of earnings data');
      print('Total bookings: $totalBookings, Total revenue: $totalRevenue');
    } catch (e) {
      print('Error fetching earnings report data: $e');
    } finally {
      isLoadingEarnings = false;
      update();
    }
  }

  // Get members report data
  Future<void> getMembersReportData(
      DateTime startDate, DateTime endDate) async {
    try {
      isLoadingMembers = true;
      update();

      // Normalize dates
      final startDateTime =
          DateTime(startDate.year, startDate.month, startDate.day);
      final endDateTime =
          DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

      // FIXED QUERY: Fetch all users since Firestore timestamp queries can be unreliable
      final usersQuery = await _firestore.collection('users').get();

      // First convert all to app users
      List<MyUser> allUsers = usersQuery.docs
          .map((doc) => MyUser.fromDocument(doc.data()))
          .toList();

      // Then manually filter by date
      membersData = allUsers.where((user) {
        if (user.createdAt == null) return false;
        return user.createdAt!
                .isAfter(startDateTime.subtract(const Duration(days: 1))) &&
            user.createdAt!.isBefore(endDateTime.add(const Duration(days: 1)));
      }).toList();

      print('Found ${membersData.length} members in the date range');

      // For each user, fetch their booking count
      for (var i = 0; i < membersData.length; i++) {
        final user = membersData[i];

        // Count bookings for this user
        final paymentsQuery = await _firestore
            .collection('payments')
            .where('userId', isEqualTo: user.id)
            .where('paymentStatus', whereIn: [
          'completed',
          'success'
        ]) // Only count successful payments
            .get();

        final bookingsCount = paymentsQuery.docs.length;

        // Update user with booking count
        membersData[i] = user.copyWith(bookingsCount: bookingsCount);
        print('User ${user.name} has $bookingsCount bookings');
      }
    } catch (e) {
      print('Error fetching members report data: $e');
    } finally {
      isLoadingMembers = false;
      update();
    }
  }

  Future<void> getCancelledTicketsData(
      DateTime startDate, DateTime endDate) async {
    try {
      isLoadingEarnings = true;
      update();

      // Normalize dates
      final startDateTime =
          DateTime(startDate.year, startDate.month, startDate.day);
      final endDateTime =
          DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

      // Fetch cancelled tickets
      final ticketsQuery = await _firestore
          .collection('tickets')
          .where('isCancelled', isEqualTo: true)
          .get();

      final userCache = <String, Map<String, dynamic>>{};

      // Process tickets with user data
      final allCancelledTickets = await Future.wait(
        ticketsQuery.docs.map((doc) async {
          final ticket = doc.data();
          final userId = ticket['userId'] as String?;

          if (userId != null && !userCache.containsKey(userId)) {
            final userDoc =
                await _firestore.collection('users').doc(userId).get();
            userCache[userId] = userDoc.data() ?? {};
          }

          return {
            ...ticket,
            'customerName': userCache[userId]?['name'] ?? 'Unknown User',
          };
        }),
      );

      // Process tickets
      final filteredCancelledTickets = allCancelledTickets.where((ticket) {
        if (ticket['cancelledAt'] == null) return false;
        final cancelDate = (ticket['cancelledAt'] as Timestamp).toDate();
        return cancelDate.isAfter(startDateTime) &&
            cancelDate.isBefore(endDateTime);
      }).toList();

      // Group by date
      final Map<String, List<Map<String, dynamic>>> ticketsByDate = {};

      for (var ticket in filteredCancelledTickets) {
        final cancelDate = (ticket['cancelledAt'] as Timestamp).toDate();
        final dateStr = DateFormat('yyyy-MM-dd').format(cancelDate);

        if (!ticketsByDate.containsKey(dateStr)) {
          ticketsByDate[dateStr] = [];
        }
        ticketsByDate[dateStr]!.add(ticket);
      }

      // Calculate daily stats
      cancelledTicketsData = [];
      totalCancelledTickets = 0;
      totalCancelledAmount = 0;

      ticketsByDate.forEach((date, tickets) {
        final count = tickets.length;
        final amount = tickets.fold<double>(
          0,
          (sum, ticket) =>
              sum + (double.tryParse(ticket['price'].toString()) ?? 0),
        );

        cancelledTicketsData.add({
          'date': _formatReportDate(date),
          'count': count.toString(),
          'amount': 'RWF ${NumberFormat("#,###").format(amount)}',
          'reasons': _getCancellationReasons(tickets),
          'customerName': tickets.map((t) => t['customerName']).join(', '),
        });

        totalCancelledTickets += count;
        totalCancelledAmount += amount;
      });

      // Sort by date
      cancelledTicketsData.sort((a, b) {
        return DateFormat('MMM dd, yyyy')
            .parse(a['date'])
            .compareTo(DateFormat('MMM dd, yyyy').parse(b['date']));
      });
    } catch (e) {
      print('Error fetching cancelled tickets data: $e');
    } finally {
      isLoadingEarnings = false;
      update();
    }
  }

  String _getCancellationReasons(List<Map<String, dynamic>> tickets) {
    final reasons = tickets
        .map((ticket) => ticket['cancellationReason'] ?? 'No reason provided')
        .toSet()
        .toList();
    return reasons.join(', ');
  }

  String _formatReportDate(String dateStr) {
    try {
      final date = DateFormat('yyyy-MM-dd').parse(dateStr);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}
