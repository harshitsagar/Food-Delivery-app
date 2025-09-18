import 'package:flutter/material.dart';
import 'package:quick_eats_app/service/database.dart';
import 'package:quick_eats_app/service/shared_pref.dart';
import 'package:quick_eats_app/widget/widget_support.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  String? wallet, id;
  int? add;
  bool isLoading = false;
  bool isProcessingPayment = false;
  TextEditingController amountcontroller = TextEditingController();

  @override
  void initState() {
    onTheLoad();
    super.initState();
  }

  getSharedPref() async {
    wallet = await SharedPreferenceHelper().getUserWallet() ?? "0";
    id = await SharedPreferenceHelper().getUserId() ?? "0";
    setState(() {});
  }

  onTheLoad() async {
    setState(() => isLoading = true);
    await getSharedPref();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
        margin: const EdgeInsets.only(top: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 2,
              child: Container(
                padding: const EdgeInsets.only(bottom: 10),
                child: Center(
                  child: Text(
                    "Wallet",
                    style: AppWidget.HeadlineTextFieldStyle(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 10, horizontal: 10),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color(0xFFF2F2F2),
              ),
              child: Row(
                children: [
                  Image.asset(
                    "images/wallet.png",
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Your Wallet",
                          style: AppWidget.LightTextFieldStyle()),
                      const SizedBox(height: 5),
                      Text(
                        "\₹${double.parse(wallet!).toStringAsFixed(2)}",
                        style: AppWidget.boldTextFieldStyle(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "Add money ",
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAmountButton("100"),
                _buildAmountButton("500"),
                _buildAmountButton("1000"),
                _buildAmountButton("2000"),
              ],
            ),
            const SizedBox(height: 50),
            GestureDetector(
              onTap: () {
                openEdit();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 50),
                padding: const EdgeInsets.symmetric(vertical: 12),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFF008080),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "Add Money",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountButton(String amount) {
    return GestureDetector(
      onTap: () => showPaymentBottomSheet(amount),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE9E2E2)),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          "\₹$amount",
          style: AppWidget.semiBoldFieldStyle(),
        ),
      ),
    );
  }

  Future<void> showPaymentBottomSheet(String amount) async {
    isProcessingPayment = false;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Add Money to Wallet",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Amount: \₹$amount",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (!isProcessingPayment) ...[
                    Text(
                      "Test Payment Method",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildPaymentMethod(
                      icon: Icons.credit_card,
                      title: "Card ending in 4242",
                      subtitle: "Visa (Test Card)",
                    ),
                  ],
                  const Spacer(),
                  if (isProcessingPayment)
                    Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          const SizedBox(height: 20),
                          Text("Processing payment..."),
                        ],
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF008080),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: isProcessingPayment
                          ? null
                          : () async {
                        setModalState(() {
                          isProcessingPayment = true;
                        });
                        // Simulate payment processing
                        await Future.delayed(Duration(seconds: 2));
                        Navigator.pop(context);
                        await addMoneyToWallet(amount);
                      },
                      child: Text(
                        isProcessingPayment ? "Processing..." : "Pay \₹$amount",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPaymentMethod({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 30),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> addMoneyToWallet(String amount) async {
    try {
      if (!mounted) return;
      setState(() => isLoading = true);

      // Clean the wallet amount by removing any non-numeric characters except decimal point
      String cleanWallet = wallet!.replaceAll(RegExp(r'[^0-9.]'), '');
      double currentBalance = double.parse(cleanWallet);

      // Clean the input amount similarly
      String cleanAmount = amount.replaceAll(RegExp(r'[^0-9.]'), '');
      double amountToAdd = double.parse(cleanAmount);

      double newBalance = currentBalance + amountToAdd;

      await SharedPreferenceHelper().saveUserWallet(newBalance.toString());
      await DatabaseMethods().UpdateUserWallet(id!, newBalance.toString());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Text("Successfully added \$$amountToAdd to wallet"),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
      }

      await getSharedPref();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future openEdit() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.cancel)),
                    const SizedBox(
                      width: 60.0,
                    ),
                    const Center(
                      child: Text(
                        "Add Money",
                        style: TextStyle(
                          color: Color(0xFF008080),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text("Amount"),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black38, width: 2.0),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    controller: amountcontroller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter Amount'),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      if (amountcontroller.text.isNotEmpty) {
                        Navigator.pop(context);
                        showPaymentBottomSheet(amountcontroller.text);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please enter an amount")));
                      }
                    },
                    child: Container(
                      width: 100,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF008080),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                          child: Text(
                            "Pay",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ));
}