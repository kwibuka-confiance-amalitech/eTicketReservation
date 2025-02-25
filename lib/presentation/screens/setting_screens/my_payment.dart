import 'package:car_ticket/controller/payments/user_payment.dart';
import 'package:car_ticket/domain/models/payment/customer_payment.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class MyPayments extends StatelessWidget {
  static const String routeName = '/my-payments';
  const MyPayments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Payments'),
      ),
      body: GetBuilder(
          init: UserPaymentController(),
          builder: (UserPaymentController userPaymentController) {
            return userPaymentController.isGettingUserPayments
                ? const SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : userPaymentController.userPayments.isEmpty
                    ? const Center(
                        child: Text('No payment history'),
                      )
                    : Container(
                        padding: const EdgeInsets.all(20),
                        child: ListView.builder(
                          itemCount: userPaymentController.userPayments.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return PaymentHistoryItem(
                                userPayment:
                                    userPaymentController.userPayments[index]);
                          },
                        ),
                      );
          }),
    );
  }
}

class PaymentHistoryItem extends StatelessWidget {
  final UserPayment userPayment;
  const PaymentHistoryItem({required this.userPayment, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(Icons.payment),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userPayment.paymentDescription,
                      style: const TextStyle(
                        color: Colors.black87, // [1
                        fontSize: 15,
                      )),
                  Text(userPayment.paymentStatus),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    userPayment.paymentDate.toString(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          Text("${userPayment.paymentAmount.toString()} RWF",
              style: const TextStyle(
                color: Colors.green,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }
}
