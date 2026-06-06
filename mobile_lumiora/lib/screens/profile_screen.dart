import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Expansion state for FAQ items
  bool isFaq1Expanded = true;
  bool isFaq2Expanded = true;

  final Color pageBg = const Color(0xFFF2EEE3);
  final Color goldAccent = const Color(0xFFBA984A);
  final Color oliveAccent = const Color(0xFF8A9219);
  final Color textBlack = const Color(0xFF000000);
  final Color textGrey = const Color(0xFF868686);
  final Color cardBorder = const Color(0x12000000); // 0.07 opacity black

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeader(),
              
              // Customer Card
              _buildCustomerCard(),
              
              const SizedBox(height: 20),
              
              // My Account Section
              _buildMyAccountSection(),
              
              const SizedBox(height: 20),
              
              // Loyalty Stamps Section
              _buildLoyaltyStampsSection(),
              
              const SizedBox(height: 20),
              
              // FAQ Section
              _buildFaqSection(),
              
              const SizedBox(height: 100), // Space for bottom nav and fab
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFloatingQrButton(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(27, 41, 27, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          Container(
            width: 74,
            height: 73,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE0E0E0),
            ),
            child: ClipOval(
              child: Container(
                 color: Colors.grey[300],
                 child: const Icon(Icons.person, size: 40, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 15),
          // Login Button
          GestureDetector(
            onTap: () {
              // Handle Login
            },
            child: Row(
              children: [
                const Text(
                  'LOGIN',
                  style: TextStyle(
                    fontFamily: 'Mallanna',
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    letterSpacing: 1.05,
                  ),
                ),
                const SizedBox(width: 5),
                Icon(Icons.arrow_forward_ios, size: 12, color: textBlack),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 31),
      width: double.infinity,
      decoration: BoxDecoration(
        color: goldAccent.withOpacity(0.25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          // Background accents
          Column(
            children: [
              Container(
                height: 81,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: goldAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                height: 36, // Partial background for the lower part
                width: double.infinity,
                color: Colors.transparent,
              ),
            ],
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CUSTOMER',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        letterSpacing: 1.05,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      height: 2,
                      width: 61,
                      color: textBlack,
                    ),
                  ],
                ),
                Container(
                  width: 62,
                  height: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFD9D9D9),
                  ),
                  child: ClipOval(
                    child: Container(
                      color: Colors.grey[400],
                      child: const Icon(Icons.person, size: 30, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 12,
            bottom: 12,
            child: Text(
              'View My Benefits',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                fontWeight: FontWeight.normal,
                color: textBlack,
                letterSpacing: 0.7,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyAccountSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MY ACCOUNT',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              letterSpacing: 0.84,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Voucher Card
              Expanded(
                child: _buildAccountInfoCard(
                  title: 'Voucher',
                  value: '0',
                  icon: Icons.confirmation_number_outlined,
                  color: oliveAccent.withOpacity(0.21),
                ),
              ),
              const SizedBox(width: 17),
              // Gift a Coffee Card
              Expanded(
                child: _buildAccountInfoCard(
                  title: 'Gift a Coffee',
                  subtitle: 'Invite and earn points',
                  icon: Icons.card_giftcard,
                  color: oliveAccent.withOpacity(0.21),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfoCard({
    required String title,
    String? value,
    String? subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      height: 88,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cardBorder),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  letterSpacing: 0.77,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 7,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                    letterSpacing: 0.49,
                  ),
                ),
              ],
              if (value != null) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 20, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text(
                      value,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        letterSpacing: 0.7,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoyaltyStampsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 34),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: oliveAccent.withOpacity(0.21),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'LOYALTY STAMPS',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  letterSpacing: 1.05,
                ),
              ),
              Text(
                '2/10',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: textGrey,
                  letterSpacing: 0.91,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Free drinks at 10 stamps. Get 10% off every stamp.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 7,
              fontWeight: FontWeight.w300,
              color: Colors.black,
              letterSpacing: 0.49,
            ),
          ),
          const SizedBox(height: 15),
          // Stamps Grid (Visual representation of Group 1)
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(10, (index) {
              bool isDone = index < 2;
              return Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone ? Colors.white : Colors.white.withOpacity(0.4),
                ),
                child: isDone
                    ? Icon(Icons.check_circle, color: oliveAccent, size: 24)
                    : null,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 33),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'FAQ',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  letterSpacing: 0.84,
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 14, color: textBlack),
            ],
          ),
          const SizedBox(height: 4),
          Container(height: 1, color: textBlack.withOpacity(0.1)),
          const SizedBox(height: 12),
          
          // FAQ Item 1
          _buildFaqItem(
            index: 1,
            question: 'How do I earn points?',
            answer: 'You can earn points by ordering through the app. Points can be redeemed for discounts or special rewards.',
            isExpanded: isFaq1Expanded,
            onToggle: () => setState(() => isFaq1Expanded = !isFaq1Expanded),
          ),
          
          const SizedBox(height: 12),
          
          // FAQ Item 2
          _buildFaqItem(
            index: 2,
            question: 'What are your opening hours?',
            answer: 'We’re open every day from 8:00 AM to 10:00 PM. Opening hours may change during holidays or special events.',
            isExpanded: isFaq2Expanded,
            onToggle: () => setState(() => isFaq2Expanded = !isFaq2Expanded),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem({
    required int index,
    required String question,
    required String answer,
    required bool isExpanded,
    required VoidCallback onToggle,
  }) {
    return GestureDetector(
      onTap: onToggle,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: const BoxDecoration(
              color: Color(0xFFE3C788),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
            child: Row(
              children: [
                Text(
                  '$index. $question',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 8,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    letterSpacing: 0.56,
                  ),
                ),
                const Spacer(),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 10,
                  color: textBlack,
                ),
              ],
            ),
          ),
          if (isExpanded)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFE4DDCE),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
              ),
              child: Text(
                answer,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 7,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  letterSpacing: 0.49,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFloatingQrButton() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 67,
          height: 67,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: oliveAccent,
            boxShadow: [
              BoxShadow(
                color: oliveAccent.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Icon(Icons.qr_code_scanner, color: Colors.white, size: 30),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'SCAN QR',
          style: TextStyle(
            fontFamily: 'Mallanna',
            fontSize: 9,
            fontWeight: FontWeight.normal,
            color: Colors.white,
            letterSpacing: 0.63,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 74,
      decoration: BoxDecoration(
        color: pageBg,
        border: Border(top: BorderSide(color: goldAccent, width: 1)),
        boxShadow: [
          BoxShadow(
            color: goldAccent.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, 'Home', false, () {
            Navigator.popUntil(context, (route) => route.isFirst);
          }),
          _buildNavItem(Icons.coffee_outlined, 'Menu', false, () {
            Navigator.pushNamed(context, '/menu');
          }),
          const SizedBox(width: 60), // Space for FAB
          _buildNavItem(Icons.receipt_long_outlined, 'History', false, () {
            Navigator.pushNamed(context, '/history');
          }),
          _buildNavItem(Icons.person_pin, 'Profile', true, () {}),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: isActive ? oliveAccent : Colors.black.withOpacity(0.5),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isActive ? oliveAccent : Colors.black.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
