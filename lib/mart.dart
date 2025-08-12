import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // 导入我们刚刚添加的 http 包
import 'dart:convert'; // 导入用于 json 解析的包

void main() {
  runApp(const BilibiliApp());
}

class BilibiliApp extends StatelessWidget {
  const BilibiliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.pink,
        fontFamily: 'sans-serif',
      ),
      home: const HomePage(),
    );
  }
}

// 我们把 HomePage 变成 StatefulWidget，因为它现在需要管理一个“状态”——视频列表
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _videos = []; // 创建一个列表来存放我们的视频数据
  bool _isLoading = true; // 创建一个状态来跟踪是否正在加载

  // 这个方法会在 Widget 第一次加载时被调用
  @override
  void initState() {
    super.initState();
    _fetchPopularVideos(); // 开始获取数据
  }

  // 异步获取热门视频数据的方法
  Future<void> _fetchPopularVideos() async {
    // 这是我们在你给的文档里找到的热门视频API地址
    final url = Uri.parse('https://api.bilibili.com/x/web-interface/popular');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // 如果服务器成功返回数据
        final decodedData = jsonDecode(response.body);
        setState(() {
          _videos = decodedData['data']['list']; // 把返回的视频列表存起来
          _isLoading = false; // 加载完成
        });
      } else {
        // 如果服务器返回错误
        setState(() {
          _isLoading = false;
        });
        // 在真实应用中，这里应该显示一个错误提示
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      // 如果网络请求本身就失败了
      setState(() {
          _isLoading = false;
      });
      print('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '哔哩哔哩 - 热门视频',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xfffb7299),
      ),
      // 这里我们用一个三元运算符来根据加载状态显示不同的界面
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // 如果正在加载，就显示一个加载圆圈
          : ListView.builder( // 如果加载完成，就显示视频列表
              padding: const EdgeInsets.all(8.0),
              itemCount: _videos.length,
              itemBuilder: (context, index) {
                final video = _videos[index];
                // 把从API获取的真实数据传给 VideoCard
                return VideoCard(
                  imageUrl: 'https:${video['pic']}', // API返回的图片链接缺了协议，我们补上
                  title: video['title'],
                  author: video['owner']['name'],
                  views: '${video['stat']['view']} 观看',
                  timestamp: '${video['stat']['like']} 点赞', // 这里我们用点赞数代替时间戳
                );
              },
            ),
    );
  }
}

// VideoCard 组件保持不变，因为它只负责显示数据
class VideoCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String author;
  final String views;
  final String timestamp;

  const VideoCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.views,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            height: 200,
            // 添加一个加载动画和错误占位图，提升体验
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              );
            },
            errorBuilder: (context, error, stackTrace) => Container(
              height: 200,
              child: Center(child: Icon(Icons.error, color: Colors.red)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8.0),
                Text(
                  '$author · $views · $timestamp',
                  style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}