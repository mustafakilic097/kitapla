import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/base/state/base_state.dart';
import '../../core/base/view/base_view.dart';
import '../../core/components/card/share_card.dart';
import '../../core/viewmodel/database.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends BaseState<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseView(
      viewModel: "",
      onPageBuilder: (context, value) {
        return NestedScrollView(
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return headArea;
          },
          body: scaffoldBody,
        );
      },
      onModelReady: (model) {},
    );
  }

  Widget get scaffoldBody => Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
        child: FutureBuilder(
          future: Db().getSharesWithId(userId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return RefreshIndicator(
              backgroundColor: Colors.white,
              color: Colors.black,
              onRefresh: () async {
                if (!mounted) return;
                setState(() {});
              },
              child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                itemCount: (snapshot.data?.keys.toList() ?? []).isEmpty
                    ? 1
                    : (snapshot.data?.keys.toList() ?? []).length,
                itemBuilder: (context, i) {
                  if ((snapshot.data?.keys.toList() ?? []).isEmpty) {
                    return const Center(
                      child: Text("Burası Boş."),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      children: [
                        buildShareCard(
                          context: context,
                          shareData: (snapshot.data?.values.toList() ?? [])[i],
                          shareId: (snapshot.data?.keys.toList() ?? [])[i],
                          userId: userId,
                        ),
                        Divider(
                          color: Colors.grey.shade300,)
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      );

  List<Widget> get headArea => [
        SliverAppBar(
          title: buildSearchArea,
          toolbarHeight: kToolbarHeight + 20,
          floating: true,
        ),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: 15, bottom: 0),
            child: Divider(
              color: Color(0xFF000000),
              height: 1,
              thickness: 0.1,
            ),
          ),
        )
      ];

  Widget get buildSearchArea => SafeArea(
        child: Row(
          children: [
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.6),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  focusNode: FocusNode(),
                  decoration: InputDecoration(
                    hintText: "Ara...",
                    hintStyle: GoogleFonts.quicksand(),
                    fillColor: Colors.grey.shade100,
                    focusedBorder: InputBorder.none,
                    filled: true,
                    prefixIcon: Icon(
                      EvaIcons.search,
                      color: Colors.grey.shade500,
                    ),
                    contentPadding: const EdgeInsets.all(8),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Image.asset(
                "assets/options.png",
                width: 22,
                height: 22,
              ),
            ),
          ],
        ),
      );
}
