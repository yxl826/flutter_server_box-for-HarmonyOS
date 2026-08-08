part of 'entry.dart';

final class _AppAboutPage extends StatefulWidget {
  const _AppAboutPage();

  @override
  State<_AppAboutPage> createState() => _AppAboutPageState();
}

final class _AppAboutPageState extends State<_AppAboutPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(13),
        children: [
          UIs.height13,
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 47, maxWidth: 47),
            child: UIs.appIcon,
          ),
          Text(
            'ServerBox For HarmonyOS\nv${OhosBuild.version}',
            textAlign: TextAlign.center,
            style: UIs.text15,
          ),
          UIs.height13,
          SizedBox(
            height: 77,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 7),
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                Btn.elevated(
                  icon: const Icon(Icons.edit_document),
                  text: l10n.wiki,
                  onTap: Urls.appWiki.launchUrl,
                ),
                Btn.elevated(
                  icon: const Icon(Icons.feedback),
                  text: libL10n.feedback,
                  onTap: Urls.appHelp.launchUrl,
                ),
                Btn.elevated(
                  icon: const Icon(MingCute.question_fill),
                  text: libL10n.license,
                  onTap: () => showLicensePage(context: context),
                ),
              ].joinWith(UIs.width13),
            ),
          ),
          UIs.height13,
          SimpleMarkdown(
            data:
                '''
鸿蒙版由 yxl826 迁移，原作者 lollipopkit

#### Contributors
${GithubIds.contributors.map((e) => e.markdownLink).join(' ')}

#### Participants
${GithubIds.participants.map((e) => e.markdownLink).join(' ')}

${l10n.madeWithLove('[lollipopkit](${Urls.myGithub})')}
''',
          ).paddingAll(13).cardx,
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
