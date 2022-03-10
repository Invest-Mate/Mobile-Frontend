import 'package:crowd_application/screens/campaign_detail/proof_preview_widget.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

class CampaignDetailScreen extends StatefulWidget {
  const CampaignDetailScreen({Key? key}) : super(key: key);

  @override
  State<CampaignDetailScreen> createState() => _CampaignDetailScreenState();
}

class _CampaignDetailScreenState extends State<CampaignDetailScreen> {
  static const List<Map<String, String>> _proofs = [
    {
      "fileName": 'image.png',
      "fileUrl":
          'https://ichef.bbci.co.uk/news/976/cpsprodpb/1622E/production/_123507609_gettyimages-1238909706-1.jpg',
    },
    {
      "fileName": 'image.png',
      "fileUrl":
          'https://www.washingtonpost.com/resizer/tiHYjregF81muYQn9UolQhalUrY=/arc-anglerfish-washpost-prod-washpost/public/FBIZA2UT2II6ZOZROT6ANQFDUU.jpg',
    },
    {
      "fileName": 'document.pdf',
      "fileUrl":
          'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
    },
    {
      "fileName": 'image.png',
      "fileUrl":
          'https://static.independent.co.uk/2022/02/22/15/09772012.jpg?quality=75&width=982&height=726&auto=webp',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          centerTitle: true,
          automaticallyImplyLeading: true,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.share))
          ],
          backgroundColor: Colors.blueGrey[800],
          pinned: true,
          expandedHeight: 300.0,
          titleSpacing: 10.0,
          flexibleSpace: FlexibleSpaceBar(
            expandedTitleScale: 1.1,
            centerTitle: true,
            // titlePadding: EdgeInsets.symmetric(),
            collapseMode: CollapseMode.parallax,
            title: const Text(
              'Russia-Ukraine War',
              textScaleFactor: 1,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              // textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            background: Image.network(
              'https://ichef.bbci.co.uk/news/976/cpsprodpb/67C5/production/_123356562_hi074059063.jpg',
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              },
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              //  raised so far and total,
              Padding(
                padding:
                    const EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Raised so far',
                          textScaleFactor: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              '\$292,487',
                              textScaleFactor: 1.5,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              width: 2.5,
                            ),
                            Text(
                              '78%',
                              textScaleFactor: 0.9,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Target',
                          textScaleFactor: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                        const Text(
                          '\$400,000',
                          textScaleFactor: 1.5,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              //progress bar
              Slider(
                thumbColor: Colors.lightGreen,
                value: 292487,
                max: 400000,
                min: 0,
                label: '78%',
                activeColor: Colors.teal,
                onChanged: (val) {},
              ),
              //total donars and time left
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: <Widget>[
                    TextButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.people_alt_outlined),
                      label: const Text(
                        '58k',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.access_time),
                      label: const Text(
                        '27 days left',
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  ],
                ),
              ),
              const Divider(
                indent: 25,
                endIndent: 25,
                thickness: 2,
              ),
              // description
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
                child: Text(
                  'Description',
                  textScaleFactor: 1.5,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 25.0,
                ),
                child: ReadMoreText(
                  'The Russo-Ukrainian War[23][d] is an ongoing war primarily involving Russia, pro-Russian forces, and Belarus on one side, and Ukraine and its international supporters on the other. Conflict began in February 2014 following the Revolution of Dignity, and focused on the status of Crimea and parts of the Donbas, internationally recognised as part of Ukraine. The conflict includes the Russian annexation of Crimea (2014), the war in Donbas (2014–present), naval incidents, cyberwarfare, and political tensions. While trying to hide its involvement, Russia gave military backing to separatists in the Donbas from 2014 onwards. Having built up a large military presence on the border from late 2021, Russia launched a full-scale invasion of Ukraine on 24 February 2022, which is ongoing.',
                  trimLines: 5,
                  trimLength: 165,
                  trimCollapsedText: 'Read more',
                  trimExpandedText: 'Show less.',
                  trimMode: TrimMode.Length,
                  textAlign: TextAlign.start,
                  moreStyle: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.black),
                  lessStyle: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.black),
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Color.fromARGB(255, 138, 137, 137),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                indent: 25,
                endIndent: 25,
                thickness: 2,
              ),
              // Proofs
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
                child: Text(
                  'Proofs',
                  textScaleFactor: 1.5,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25.0, vertical: 5),
                child: SizedBox(
                  height: 100,
                  width: double.maxFinite,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _proofs.length,
                    itemBuilder: (context, i) => ProofPreview(
                        fileName: _proofs[i]['fileName']!,
                        fileUrl: _proofs[i]['fileUrl']!),
                  ),
                ),
              ),
              //send donations button
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, left: 25, right: 25, bottom: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      primary: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 15)),
                  onPressed: () {},
                  child: const Text('Send Donation'),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
