import 'package:flutter/material.dart';

void main() => runApp(const NavigacijaApp());

class NavigacijaApp extends StatelessWidget {
  const NavigacijaApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Primjeri navigacije',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      useMaterial3: true,
    ),
    home: const GlavniEkran(),
  );
}

class GlavniEkran extends StatefulWidget {
  const GlavniEkran({super.key});

  @override
  State<GlavniEkran> createState() => _GlavniEkranState();
}

class _GlavniEkranState extends State<GlavniEkran> {
  int odabrano = 0;
  final naslovi = ['Početna', 'Kartice', 'Profil'];
  final ikone = [Icons.home_outlined, Icons.tab, Icons.person_outline];

  // Navigator otvara novi ekran i šalje mu podatak kroz konstruktor.
  void otvoriDetalje(String poruka) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => DetaljiEkran(poruka: poruka)),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(naslovi[odabrano]),
      actions: [
        // Padajući izbornik za dodatne mogućnosti.
        MenuAnchor(
          menuChildren: [
            MenuItemButton(
              onPressed: () => otvoriDetalje('Jednostavan Flutter primjer.'),
              child: const Text('O aplikaciji'),
            ),
          ],
          builder: (context, controller, child) => IconButton(
            tooltip: 'Više mogućnosti',
            icon: const Icon(Icons.more_vert),
            onPressed: () =>
                controller.isOpen ? controller.close() : controller.open(),
          ),
        ),
      ],
    ),
    // Bočni izbornik: odabir ekrana i zatvaranje izbornika.
    drawer: Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const ListTile(title: Text('Primjeri navigacije')),
            const Divider(),
            for (int i = 0; i < naslovi.length; i++)
              ListTile(
                leading: Icon(ikone[i]),
                title: Text(naslovi[i]),
                selected: odabrano == i,
                onTap: () {
                  setState(() => odabrano = i);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    ),
    // IndexedStack prikazuje odabrani dio i čuva stanje ostalih.
    body: IndexedStack(
      index: odabrano,
      children: [
        Sadrzaj(
          naslov: 'Početna',
          tekst: 'Odaberi ekran donjom navigacijom ili bočnim izbornikom.',
          ikona: Icons.home_outlined,
          gumb: FilledButton(
            onPressed: () => otvoriDetalje('Pozdrav s početne!'),
            child: const Text('Otvori detalje i pošalji poruku'),
          ),
        ),
        const KarticeEkran(),
        const Sadrzaj(
          naslov: 'Profil',
          tekst: 'Ime: Student\nOvo je treći ekran donje navigacije.',
          ikona: Icons.person_outline,
        ),
      ],
    ),
    // Donja navigacija mijenja odabrani indeks.
    bottomNavigationBar: NavigationBar(
      selectedIndex: odabrano,
      onDestinationSelected: (index) => setState(() => odabrano = index),
      destinations: [
        for (int i = 0; i < naslovi.length; i++)
          NavigationDestination(icon: Icon(ikone[i]), label: naslovi[i]),
      ],
    ),
  );
}

// Gornje kartice organiziraju sadržaj unutar jednog ekrana.
class KarticeEkran extends StatelessWidget {
  const KarticeEkran({super.key});

  @override
  Widget build(BuildContext context) => const DefaultTabController(
    length: 2,
    child: Column(
      children: [
        TabBar(
          tabs: [
            Tab(text: 'Opis'),
            Tab(text: 'Primjer'),
          ],
        ),
        Expanded(
          child: TabBarView(
            children: [
              Sadrzaj(
                naslov: 'Opis',
                tekst: 'Gornje kartice mijenjaju sadržaj ovog ekrana.',
                ikona: Icons.info_outline,
              ),
              Sadrzaj(
                naslov: 'Primjer',
                tekst: 'Ovo je druga kartica. Možeš i povući lijevo/desno.',
                ikona: Icons.swipe,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// Novi ekran prima poruku; AppBar automatski dodaje strelicu za povratak.
class DetaljiEkran extends StatelessWidget {
  const DetaljiEkran({super.key, required this.poruka});
  final String poruka;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Detalji')),
    body: Sadrzaj(
      naslov: 'Primljeni podatak',
      tekst: poruka,
      ikona: Icons.chat_bubble_outline,
    ),
  );
}

// Ponovno upotrebljiv dio sučelja, s podacima koje mu šalje pozivatelj.
class Sadrzaj extends StatelessWidget {
  const Sadrzaj({
    super.key,
    required this.naslov,
    required this.tekst,
    required this.ikona,
    this.gumb,
  });
  final String naslov;
  final String tekst;
  final IconData ikona;
  final Widget? gumb;

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ikona, size: 48, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 16),
          Text(naslov, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(tekst, textAlign: TextAlign.center),
          if (gumb != null) ...[const SizedBox(height: 24), gumb!],
        ],
      ),
    ),
  );
}
