import 'package:cached_network_image/cached_network_image.dart';
import 'package:crowd_application/screens/campaign_detail/campaign_detail_screen.dart';
import 'package:flutter/material.dart';

class FundItem extends StatelessWidget {
  const FundItem({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.lastDate,
    required this.totalAmount,
    required this.receivedAmount,
    this.fundId = "626e4c4c2e29d5c801261bdc",
    this.isMyFund = false,
  }) : super(key: key);
  final String title;
  final String imageUrl;
  final DateTime lastDate;
  final double totalAmount;
  final double receivedAmount;
  final bool isMyFund;
  final String fundId;
  @override
  Widget build(BuildContext context) {
    final progress = (receivedAmount / totalAmount).toDouble();
    final timeLeft = lastDate.difference(DateTime.now()).inDays;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CampaignDetailScreen(
                isMyFund: isMyFund,
                fundId: fundId,
              ),
            ),
          );
        },
        child: Container(
          height: 100,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                  width: 1, color: const Color.fromRGBO(197, 197, 197, 1))),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 100,
                width: 120,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                    child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                      color: Colors.black,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        textScaleFactor: 1.2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: SliderTheme(
                          data: SliderThemeData(
                            overlayShape: SliderComponentShape.noOverlay,
                            disabledActiveTrackColor:
                                const Color.fromRGBO(254, 161, 21, 0.81),
                            thumbShape: SliderComponentShape.noThumb,
                          ),
                          child: Slider(
                            value: progress,
                            onChanged: null,
                          ),
                        ),
                      ),
                      Row(
                        // mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.monetization_on_outlined,
                                size: 15,
                                color: Color.fromRGBO(147, 147, 147, 1),
                              ),
                              const SizedBox(
                                width: 2.5,
                              ),
                              Text(
                                (progress * 100).toStringAsFixed(0) + '%',
                                textScaleFactor: 0.9,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 15,
                                color: Color.fromRGBO(147, 147, 147, 1),
                              ),
                              const SizedBox(
                                width: 2.5,
                              ),
                              Text(
                                timeLeft.isNegative
                                    ? 'Expired'
                                    : timeLeft > 28
                                        ? '${(timeLeft / 30).round()} Months left'
                                        : '$timeLeft Days left',
                                textScaleFactor: 0.9,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
