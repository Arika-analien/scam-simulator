import 'package:flutter/material.dart';

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Hiện Pop-up ngay khi vừa vào màn hình chính (đợi build frame đầu tiên xong)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWorkingHoursPopup();
    });
  }

  void _showWorkingHoursPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blueAccent),
              SizedBox(width: 8),
              Text('Khung giờ hoạt động', style: TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
          content: const Text(
            'Để không ảnh hưởng đến thời gian nghỉ ngơi, các kịch bản giả lập sẽ chỉ hoạt động trong khung giờ:\n\n'
            '📞 Cuộc gọi: 07:00 - 22:00\n'
            '💬 Tin nhắn: 07:00 - 24:00',
            style: TextStyle(color: Colors.white70, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Đã hiểu', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark mode default
      appBar: AppBar(
        title: const Text('Scam Simulator', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.grey[900],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // 1. Banner Slide Cập nhật tin tức
            SizedBox(
              height: 150,
              child: PageView(
                controller: PageController(viewportFraction: 0.9),
                children: [
                  _buildBannerItem(
                    'Cảnh báo lừa đảo: Bắt cóc tống tiền',
                    'Kịch bản giả mạo giáo viên gọi điện báo con cấp cứu đang rộ lên...',
                    Colors.redAccent.withOpacity(0.8),
                  ),
                  _buildBannerItem(
                    'Update AI: Cải thiện giọng nói',
                    'Bản cập nhật mới giúp AI giả giọng chuẩn xác hơn 40% so với trước.',
                    Colors.blueAccent.withOpacity(0.8),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 2. Bố cục Grid 2x2 (4 Menu)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  _buildMenuCard(Icons.person, 'Thông tin tài khoản', Colors.orange),
                  _buildMenuCard(Icons.chat_bubble, 'AI Chat', Colors.green),
                  _buildMenuCard(Icons.warning_amber, 'Những vụ lừa đảo', Colors.red),
                  _buildMenuCard(Icons.lightbulb_outline, 'Tips tránh lừa đảo', Colors.yellow),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 3. Lịch sử lừa từ app (Dạng danh sách cuộn dọc)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Lịch sử lừa từ app',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5, // Demo 5 mục
              itemBuilder: (context, index) {
                return _buildHistoryItem(index);
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerItem(String title, String subtitle, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildMenuCard(IconData icon, String title, Color iconColor) {
    return InkWell(
      onTap: () {
        // Handle menu click
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[800]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: iconColor),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(int index) {
    final bool isCall = index % 2 == 0;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isCall ? Colors.redAccent.withOpacity(0.2) : Colors.greenAccent.withOpacity(0.2),
          child: Icon(
            isCall ? Icons.phone_missed : Icons.message,
            color: isCall ? Colors.redAccent : Colors.greenAccent,
          ),
        ),
        title: Text(
          isCall ? 'Giả mạo Công an phường' : 'Tin nhắn trúng thưởng',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Hôm qua, 14:30',
          style: TextStyle(color: Colors.grey[400], fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}
