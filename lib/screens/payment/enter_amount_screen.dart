import 'package:crowd_application/screens/payment/input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EnterAmountScreen extends StatelessWidget {
  const EnterAmountScreen({Key? key}) : super(key: key);
  final InputDecoration _decoration = const InputDecoration(
    filled: true,
    fillColor: Color.fromARGB(255, 247, 246, 247),
    border: InputBorder.none,
    focusedBorder: InputBorder.none,
    enabledBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    contentPadding: EdgeInsets.symmetric(horizontal: 15),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: const Color.fromRGBO(31, 24, 53, 1),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Form(
              child: SizedBox(
                  width: double.maxFinite,
                  // height: double.maxFinite,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Center(
                          child: Container(
                            // padding: EdgeInsets.symmetric(horizontal: 15),
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 42, 37, 65),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 15),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Enter Amount",
                                  textScaleFactor: 1.5,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15.0),
                                  child: TextFormField(
                                    style: const TextStyle(color: Colors.white),
                                    validator: (value) {
                                      int val = int.parse(value!);
                                      if (val == 0) {
                                        return "Enter Amount.";
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      prefix: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Text(
                                          "Rs",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 15),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 2,
                                          color: Colors.white,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 2.5,
                                          color: Colors.white,
                                          // color: Colors.blue,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 2.5,
                                          color: Colors.white,
                                          // color: Colors.blue,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          width: 2.5,
                                          color: Colors.white,
                                          // color: Colors.blue,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        // height: 800,
                        width: double.maxFinite,
                        margin: const EdgeInsets.only(top: 15),
                        padding: const EdgeInsets.symmetric(
                            vertical: 25, horizontal: 30),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 254, 254, 254),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text(
                                "Cardholder's Name",
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              clipBehavior: Clip.antiAlias,
                              child: TextFormField(
                                onSaved: ((newValue) {}),
                                keyboardType: TextInputType.name,
                                decoration: _decoration,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text(
                                "Card Number",
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              clipBehavior: Clip.antiAlias,
                              child: TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(19),
                                  CardNumberInputFormatter(),
                                ],
                                keyboardType: TextInputType.number,
                                decoration: _decoration,
                                onSaved: (value) {},
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5.0),
                                      child: Text(
                                        "CVV",
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      clipBehavior: Clip.antiAlias,
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        decoration: _decoration,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5.0),
                                      child: Text(
                                        "Expiry date",
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      clipBehavior: Clip.antiAlias,
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        decoration: _decoration,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 20),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        const Size(double.maxFinite, 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    primary:
                                        const Color.fromARGB(255, 253, 73, 12),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                    )),
                                onPressed: () {},
                                child: const Text('Pay Now'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
