
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'materials_seed.dart';

const navy = Color(0xFF07182D), panel = Color(0xFF102943), blue = Color(0xFF39A9FF), muted = Color(0xFF9BB2C9);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MaterialStore.instance.database;
  runApp(const SemiAUseApp());
}

class MaterialStore {
  MaterialStore._();
  static final instance = MaterialStore._();
  Database? _db;
  Future<Database> get database async {
    if (_db != null) return _db!;
    final path = await getDatabasesPath();
    _db = await openDatabase(p.join(path, 'semi_a_use.db'), version: 1,
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE materials(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, formula TEXT NOT NULL, tc REAL NOT NULL, type TEXT NOT NULL, field TEXT NOT NULL, description TEXT NOT NULL, applications TEXT NOT NULL, note TEXT NOT NULL)");
        final batch = db.batch();
        for (final m in seedMaterials) { batch.insert('materials', m); }
        await batch.commit(noResult: true);
      });
    return _db!;
  }
  Future<List<Map<String,Object?>>> all() async => (await database).query('materials', orderBy: 'tc ASC');
  Future<List<Map<String,Object?>>> search(String q, String type) async {
    final clauses = <String>[], args = <Object>[];
    if (q.trim().isNotEmpty) { clauses.add('(name LIKE ? OR formula LIKE ?)'); args.addAll(['%${q.trim()}%','%${q.trim()}%']); }
    if (type != 'All') { clauses.add('type = ?'); args.add(type); }
    return (await database).query('materials', where: clauses.isEmpty ? null : clauses.join(' AND '), whereArgs: args.isEmpty ? null : args, orderBy: 'tc ASC');
  }
}

class SemiAUseApp extends StatelessWidget {
  const SemiAUseApp({super.key});
  @override Widget build(BuildContext context) => MaterialApp(
    title: 'Semi-A-Use', debugShowCheckedModeBanner: false,
    theme: ThemeData(brightness: Brightness.dark, scaffoldBackgroundColor: navy,
      colorScheme: const ColorScheme.dark(primary: blue, secondary: blue, surface: panel), useMaterial3: true,
      appBarTheme: const AppBarTheme(backgroundColor: navy, elevation: 0),
      cardTheme: CardThemeData(color: panel, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)))),
    home: const HomeShell());
}

class HomeShell extends StatefulWidget { const HomeShell({super.key}); @override State<HomeShell> createState()=>_HomeShellState(); }
class _HomeShellState extends State<HomeShell> {
  int index=0;
  final pages = const [HomePage(), MaterialsPage(), LearnPage(), QuizPage(), AboutPage()];
  @override Widget build(BuildContext context)=>Scaffold(
    body: SafeArea(child: IndexedStack(index:index, children:pages)),
    bottomNavigationBar: NavigationBar(backgroundColor: const Color(0xFF0B2038), indicatorColor: blue.withOpacity(.2), selectedIndex:index,
      onDestinationSelected:(v)=>setState(()=>index=v),
      destinations: const [
        NavigationDestination(icon:Icon(Icons.home_outlined),selectedIcon:Icon(Icons.home),label:'Home'),
        NavigationDestination(icon:Icon(Icons.science_outlined),selectedIcon:Icon(Icons.science),label:'Materials'),
        NavigationDestination(icon:Icon(Icons.menu_book_outlined),selectedIcon:Icon(Icons.menu_book),label:'Learn'),
        NavigationDestination(icon:Icon(Icons.quiz_outlined),selectedIcon:Icon(Icons.quiz),label:'Quiz'),
        NavigationDestination(icon:Icon(Icons.info_outline),selectedIcon:Icon(Icons.info),label:'About')]));
}

class Heading extends StatelessWidget {
  final String eyebrow,title,subtitle;
  const Heading(this.eyebrow,this.title,this.subtitle,{super.key});
  @override Widget build(BuildContext context)=>Padding(padding:const EdgeInsets.fromLTRB(20,18,20,14),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
    Text(eyebrow.toUpperCase(),style:const TextStyle(color:blue,fontSize:11,letterSpacing:2,fontWeight:FontWeight.bold)),
    const SizedBox(height:7),Text(title,style:const TextStyle(fontSize:28,fontWeight:FontWeight.w800)),
    const SizedBox(height:5),Text(subtitle,style:const TextStyle(color:muted,height:1.4))]));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override Widget build(BuildContext context)=>FutureBuilder(future:MaterialStore.instance.all(),builder:(context,snap){
    final count=snap.data?.length??12;
    return ListView(padding:const EdgeInsets.only(bottom:24),children:[
      Padding(padding:const EdgeInsets.fromLTRB(20,22,20,8),child:Row(children:[
        Container(width:44,height:44,decoration:BoxDecoration(color:blue.withOpacity(.15),borderRadius:BorderRadius.circular(14)),child:const Icon(Icons.bolt,color:blue,size:28)),
        const SizedBox(width:12),const Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Text('SEMI-A-USE',style:TextStyle(fontWeight:FontWeight.w900,letterSpacing:2,fontSize:17)),
          Text('SUPERCONDUCTIVITY LEARNING LAB',style:TextStyle(color:muted,fontSize:9,letterSpacing:1))]) ])),
      Container(margin:const EdgeInsets.all(18),padding:const EdgeInsets.all(22),decoration:BoxDecoration(borderRadius:BorderRadius.circular(24),gradient:const LinearGradient(colors:[Color(0xFF123B63),Color(0xFF0D2946),Color(0xFF10243A)],begin:Alignment.topLeft,end:Alignment.bottomRight),border:Border.all(color:blue.withOpacity(.25))),
        child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          const Text('EXPLORE THE EXTRAORDINARY',style:TextStyle(color:Color(0xFF8CCFFF),fontSize:10,letterSpacing:1.7,fontWeight:FontWeight.bold)),
          const SizedBox(height:13),const Text('Discover the world of\nsuperconductors.',style:TextStyle(fontSize:29,height:1.12,fontWeight:FontWeight.w800)),
          const SizedBox(height:12),const Text('Learn how certain materials carry electric current with zero DC resistance and expel magnetic fields.',style:TextStyle(color:Color(0xFFC2D4E5),height:1.5)),
          const SizedBox(height:18),Row(children:[_stat('$count','MATERIALS'),const SizedBox(width:22),_stat('100%','OFFLINE'),const SizedBox(width:22),_stat('5','SECTIONS')]) ])),
      const Padding(padding:EdgeInsets.fromLTRB(20,4,20,12),child:Text('START EXPLORING',style:TextStyle(fontSize:12,letterSpacing:1.5,color:muted,fontWeight:FontWeight.bold))),
      _tile(context,1,Icons.science,'Material database','Compare Tc, type and critical fields'),
      _tile(context,2,Icons.auto_stories,'Learn the fundamentals','Meissner effect, critical temperature and more'),
      _tile(context,3,Icons.psychology_alt,'Test your knowledge','Take a short superconductivity quiz'),
      const Padding(padding:EdgeInsets.fromLTRB(20,16,20,4),child:Text('A QUICK CONCEPT',style:TextStyle(fontSize:12,letterSpacing:1.5,color:muted,fontWeight:FontWeight.bold))),
      const Card(child:Padding(padding:EdgeInsets.all(17),child:Text('A superconductor is a material that, below a transition temperature, enters a state with zero DC electrical resistance and expels magnetic flux under suitable conditions.',style:TextStyle(height:1.55))))]);
  });
  static Widget _stat(String v,String l)=>Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Text(v,style:const TextStyle(fontSize:20,fontWeight:FontWeight.w800,color:Colors.white)),Text(l,style:const TextStyle(fontSize:8,letterSpacing:1,color:Color(0xFF9BB9D2)))]);
  static Widget _tile(BuildContext c,int i,IconData icon,String title,String sub)=>Card(margin:const EdgeInsets.fromLTRB(18,5,18,7),child:ListTile(onTap:(){c.findAncestorStateOfType<_HomeShellState>()?.setState(()=>c.findAncestorStateOfType<_HomeShellState>()!.index=i);},leading:Icon(icon,color:blue),title:Text(title,style:const TextStyle(fontWeight:FontWeight.bold)),subtitle:Text(sub,style:const TextStyle(color:muted,fontSize:12)),trailing:const Icon(Icons.arrow_forward_ios,size:15)));
}

class MaterialsPage extends StatefulWidget { const MaterialsPage({super.key}); @override State<MaterialsPage> createState()=>_MaterialsPageState(); }
class _MaterialsPageState extends State<MaterialsPage> {
  String query='',type='All';
  @override Widget build(BuildContext context)=>Column(children:[
    const Heading('LOCAL DATABASE','Materials','Explore superconductors and compare their properties.'),
    Padding(padding:const EdgeInsets.symmetric(horizontal:18),child:TextField(onChanged:(v)=>setState(()=>query=v),decoration:InputDecoration(prefixIcon:const Icon(Icons.search,color:muted),hintText:'Search name or formula',filled:true,fillColor:panel,border:OutlineInputBorder(borderRadius:BorderRadius.circular(15),borderSide:BorderSide.none)))),
    const SizedBox(height:12),
    Padding(padding:const EdgeInsets.symmetric(horizontal:18),child:Row(children:[for(final t in ['All','Type-I','Type-II']) Padding(padding:const EdgeInsets.only(right:8),child:ChoiceChip(label:Text(t),selected:type==t,onSelected:(_)=>setState(()=>type=t)))])),
    const SizedBox(height:4),Expanded(child:FutureBuilder(future:MaterialStore.instance.search(query,type),builder:(context,snap){
      if(!snap.hasData)return const Center(child:CircularProgressIndicator());
      final rows=snap.data!; if(rows.isEmpty)return const Center(child:Text('No matching materials found.',style:TextStyle(color:muted)));
      return ListView.builder(
  padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
  itemCount: rows.length,
  itemBuilder: (context, i) {
    final m = rows[i];

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 7,
        ),
        title: Text(
          m['name'] as String,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text('${m['formula']} • ${m['type']}'),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MaterialDetail(material: m),
            ),
          );
        },
      ),
    );
    });)]);
}

class MaterialDetail extends StatelessWidget {
  final Map<String,Object?> material; const MaterialDetail({super.key,required this.material});
  @override Widget build(BuildContext context){final m=material;return Scaffold(appBar:AppBar(title:const Text('Material details')),body:ListView(padding:const EdgeInsets.all(18),children:[
    Container(padding:const EdgeInsets.all(21),decoration:BoxDecoration(borderRadius:BorderRadius.circular(22),gradient:const LinearGradient(colors:[Color(0xFF16446D),Color(0xFF102943)])),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Text(m['type'] as String,style:const TextStyle(color:Color(0xFF9BD4FF),fontWeight:FontWeight.bold,letterSpacing:1)),
      const SizedBox(height:12),Text(m['name'] as String,style:const TextStyle(fontSize:25,fontWeight:FontWeight.w800)),
      const SizedBox(height:5),Text(m['formula'] as String,style:const TextStyle(color:Color(0xFFC5D9EA),fontSize:17)),
      const SizedBox(height:20),Text('${(m['tc'] as num).toStringAsFixed(2)} K',style:const TextStyle(fontSize:38,color:Colors.white,fontWeight:FontWeight.w900)),
      const Text('CRITICAL TEMPERATURE (Tc)',style:TextStyle(color:Color(0xFF9FC6E5),fontSize:10,letterSpacing:1.3))])),
    _section('Classification',Text(m['type'] as String,style:const TextStyle(fontSize:17,color:blue,fontWeight:FontWeight.bold))),
    _section('Critical magnetic field',Text(m['field'] as String,style:const TextStyle(height:1.5))),
    _section('About this material',Text(m['description'] as String,style:const TextStyle(height:1.55))),
    _section('Important applications',Text(m['applications'] as String,style:const TextStyle(height:1.55))),
    _section('Scientific note',Text(m['note'] as String,style:const TextStyle(color:muted,height:1.5))) ]));}
}

Widget _section(String title,Widget child)=>Card(margin:const EdgeInsets.only(top:12),child:Padding(padding:const EdgeInsets.all(17),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
  Text(title.toUpperCase(),style:const TextStyle(color:blue,fontSize:11,fontWeight:FontWeight.bold,letterSpacing:1.1)),const SizedBox(height:10),child])));

class LearnPage extends StatelessWidget {
  const LearnPage({super.key});
  static const topics=[
    ('What is superconductivity?','Superconductivity is a state in which a material exhibits zero DC electrical resistance and expels magnetic flux when cooled below its transition temperature, under suitable magnetic-field conditions.',Icons.bolt),
    ('Critical temperature (Tc)','Tc is the transition temperature below which a material becomes superconducting. It is measured in kelvin (K). Composition, pressure, sample quality and measurement conditions can affect it.',Icons.thermostat),
    ('The Meissner effect','When a material enters the superconducting state, it expels magnetic flux from its interior under suitable conditions. This distinguishes superconductivity from merely perfect conductivity.',Icons.blur_on),
    ('Type-I and Type-II','Type-I superconductors have one thermodynamic critical field and show an abrupt transition to the normal state. Type-II superconductors have lower and upper critical fields (Hc1 and Hc2), with a mixed vortex state between them.',Icons.compare_arrows),
    ('Critical magnetic field','A sufficiently strong magnetic field can destroy superconductivity. Type-I materials are described by Hc. Type-II materials are described by Hc1 and Hc2. Values depend on temperature, material and field direction.',Icons.waves),
    ('Why applications matter','Superconductors can create powerful magnets and carry large currents with very low energy loss in the superconducting state. Cooling, cost, mechanical strength and magnetic-field limits remain engineering challenges.',Icons.public)];
  @override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.only(bottom:20),children:[
    const Heading('LEARNING CENTRE','Learn','Build your understanding one concept at a time.'),
    ...topics.map((t)=>Card(margin:const EdgeInsets.fromLTRB(18,5,18,7),child:ExpansionTile(leading:Icon(t.$3,color:blue),title:Text(t.$1,style:const TextStyle(fontWeight:FontWeight.bold)),children:[Padding(padding:const EdgeInsets.fromLTRB(18,0,18,18),child:Text(t.$2,style:const TextStyle(color:Color(0xFFC5D5E4),height:1.6)))])))]);
}

class QuizPage extends StatefulWidget { const QuizPage({super.key}); @override State<QuizPage> createState()=>_QuizPageState(); }
class _QuizPageState extends State<QuizPage> {
  final qs=const[
    ('What is the SI unit commonly used for critical temperature?',['Kelvin','Tesla','Ohm','Watt'],0,'Critical temperature is expressed in kelvin (K).'),
    ('Which effect describes magnetic-flux expulsion?',['Hall effect','Meissner effect','Photoelectric effect','Doppler effect'],1,'The Meissner effect is magnetic-flux expulsion on entering the superconducting state.'),
    ('Which is a Type-I superconductor?',['Nb-Ti','YBCO','Lead','MgB₂'],2,'Lead is a classic elemental Type-I superconductor.'),
    ('What are the two critical fields of a Type-II superconductor?',['Hc and Tc','Hc1 and Hc2','E1 and E2','B and R'],1,'Type-II superconductors have lower and upper critical fields Hc1 and Hc2.'),
    ('Which material has Tc around 39 K?',['MgB₂','Mercury','Lead','Nb'],0,'Magnesium diboride has a transition temperature around 39 K.'),
    ('Which material is widely used in MRI magnet windings?',['Mercury','Nb-Ti','H₃S','Lead'],1,'Nb-Ti is widely used in MRI and other superconducting magnets.'),
    ('At approximately what temperature does YBCO become superconducting?',['4 K','18 K','92 K','203 K'],2,'Optimally oxygenated YBCO has Tc around 90–93 K.'),
    ('What is the runtime internet requirement of this app?',['Wi-Fi','Mobile data','Internet login','None'],3,'Learning content and the database are stored locally.')];
  int current=0,score=0; int? selected; bool finished=false;
  void choose(int i){if(selected!=null)return;setState(() { selected=i; if(i==qs[current].$3) score++; });}
  void next(){setState(() { if(current==qs.length-1){finished=true;}else{current++;selected=null;} });}
  void restart(){setState(() { current=0;score=0;selected=null;finished=false; });}
  @override Widget build(BuildContext context){
    if(finished)return Center(child:Padding(padding:const EdgeInsets.all(24),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
      const Icon(Icons.emoji_events,size:72,color:blue),const SizedBox(height:18),const Text('Quiz complete!',style:TextStyle(fontSize:27,fontWeight:FontWeight.w800)),
      const SizedBox(height:8),Text('$score / ${qs.length}',style:const TextStyle(fontSize:42,color:blue,fontWeight:FontWeight.w900)),
      Text('You answered ${(score/qs.length*100).round()}% correctly.',style:const TextStyle(color:muted)),const SizedBox(height:22),
      FilledButton.icon(onPressed:restart,icon:const Icon(Icons.refresh),label:const Text('Try again'))])));
    final q=qs[current];return ListView(padding:const EdgeInsets.all(20),children:[
      const Heading('KNOWLEDGE CHECK','Quick Quiz','Check what you have learned.'),
      LinearProgressIndicator(value:(current+1)/qs.length,backgroundColor:panel,color:blue,minHeight:7,borderRadius:BorderRadius.circular(8)),
      const SizedBox(height:12),Text('QUESTION ${current+1} OF ${qs.length}',style:const TextStyle(color:muted,letterSpacing:1,fontSize:11)),
      const SizedBox(height:14),Text(q.$1,style:const TextStyle(fontSize:22,fontWeight:FontWeight.bold,height:1.3)),const SizedBox(height:20),
      ...List.generate(q.$2.length,(i){final chosen=selected==i,correct=q.$3==i;Color? bg;if(selected!=null&&correct)bg=Colors.green.withOpacity(.18);else if(selected!=null&&chosen)bg=Colors.red.withOpacity(.16);
        return Card(color:bg??panel,child:ListTile(onTap:selected==null?()=>choose(i):null,leading:CircleAvatar(backgroundColor:const Color(0xFF1B3A56),child:Text(String.fromCharCode(65+i))),title:Text(q.$2[i]),trailing:selected==null?null:Icon(correct?Icons.check_circle:(chosen?Icons.cancel:Icons.circle_outlined),color:correct?Colors.greenAccent:(chosen?Colors.redAccent:muted))));}),
      if(selected!=null)...[const SizedBox(height:12),Card(child:Padding(padding:const EdgeInsets.all(15),child:Text(q.$4,style:const TextStyle(height:1.5)))),const SizedBox(height:10),FilledButton(onPressed:next,child:Text(current==qs.length-1?'See results':'Next question'))]]);
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override Widget build(BuildContext context)=>ListView(padding:const EdgeInsets.only(bottom:24),children:[
    const Heading('PROJECT INFORMATION','About','A compact offline guide to superconducting materials.'),
    Container(margin:const EdgeInsets.all(18),padding:const EdgeInsets.all(24),decoration:BoxDecoration(color:panel,borderRadius:BorderRadius.circular(22)),child:const Column(children:[
      Icon(Icons.science,size:54,color:blue),SizedBox(height:14),Text('SEMI-A-USE',style:TextStyle(fontSize:25,fontWeight:FontWeight.w900,letterSpacing:2)),
      SizedBox(height:6),Text('Version 1.0.0',style:TextStyle(color:muted)),SizedBox(height:18),
      Text('An educational mobile application designed to introduce superconductivity, compare material properties and explain important applications. All learning content is stored locally for offline access.',textAlign:TextAlign.center,style:TextStyle(height:1.6))])),
    _section('Offline by design',const Text('The app uses a local SQLite database created on the device. It does not need an account, remote server or internet connection to browse materials, read lessons or complete the quiz.')),
    _section('Academic note',const Text('Critical temperatures and magnetic-field values are representative values. They can vary with composition, pressure, sample quality, temperature and field orientation. Consult scientific references before using values in formal research.')),
    _section('Developer details',const Text('Student project • Developer details can be added before final submission.'))]);
}
