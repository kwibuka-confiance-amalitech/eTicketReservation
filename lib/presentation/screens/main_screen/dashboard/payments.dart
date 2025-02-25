import 'package:car_ticket/controller/payments/dashboard_payment.dart';
import 'package:car_ticket/presentation/screens/setting_screens/my_payment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentsScreen extends StatelessWidget {
  static const String routeName = 'dashboard/payments';
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GetBuilder(
            init: DashboardPaymentController(),
            builder: (DashboardPaymentController userPaymentController) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                      title: const Text('Payments'),
                      floating: true,
                      snap: true,
                      pinned: true,
                      centerTitle: true,
                      backgroundColor: Theme.of(context).primaryColor,
                      expandedHeight: 200,
                      foregroundColor: Colors.white,
                      flexibleSpace: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).primaryColor,
                                Theme.of(context).primaryColor.withOpacity(0.8)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Align(
                              alignment: Alignment.center,
                              child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        height: 60,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 5.0),
                                            child: Text("RWF",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.white)),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                              userPaymentController.totalAmount
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                        ],
                                      ),
                                      const Text('Tatal Payments',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300)),
                                    ],
                                  ))))),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Container(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20, top: 20, bottom: 0),
                          child: const Row(
                            children: [
                              Text('All Payments',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        userPaymentController.isGettingUserPayments
                            ? const SizedBox(
                                width: double.infinity,
                                height: 200,
                                child:
                                    Center(child: CircularProgressIndicator()),
                              )
                            : userPaymentController.userPayments.isEmpty
                                ? const Center(
                                    child: Text('No payment history'),
                                  )
                                : Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Column(
                                      children: [
                                        ListView.builder(
                                          itemCount: userPaymentController
                                              .userPayments.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return PaymentHistoryItem(
                                                userPayment:
                                                    userPaymentController
                                                        .userPayments[index]);
                                          },
                                        ),
                                        const SizedBox(
                                          height: 200,
                                        )
                                      ],
                                    ),
                                  )
                      ],
                    ),
                  ),
                ],
              );
            }));
  }
}
