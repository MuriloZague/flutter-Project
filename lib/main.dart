import 'package:flutter/material.dart';

void main() {
  runApp(const SistemaAcademicoApp());
}

class SistemaAcademicoApp extends StatelessWidget {
  const SistemaAcademicoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistema Acadêmico',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();

  final _raController = TextEditingController();
  final _nomeController = TextEditingController();
  final _disciplinaController = TextEditingController();
  final _trabalhoController = TextEditingController();
  final _avaliacaoController = TextEditingController();

  double? _media;
  String? _situacao;

  @override
  void dispose() {
    _raController.dispose();
    _nomeController.dispose();
    _disciplinaController.dispose();
    _trabalhoController.dispose();
    _avaliacaoController.dispose();

    super.dispose();
  }

  void calcularMedia() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final double trabalho =
        double.parse(_trabalhoController.text.replaceAll(',', '.'));

    final double avaliacao =
        double.parse(_avaliacaoController.text.replaceAll(',', '.'));

    final double media = (trabalho * 4 + avaliacao * 6) / 10;

    setState(() {
      _media = media;
      _situacao = media >= 6 ? 'Aprovado' : 'Reprovado';
    });
  }

  void limparCampos() {
    _formKey.currentState?.reset();

    _raController.clear();
    _nomeController.clear();
    _disciplinaController.clear();
    _trabalhoController.clear();
    _avaliacaoController.clear();

    setState(() {
      _media = null;
      _situacao = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        title: const Text(
          'Sistema Acadêmico',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Limpar formulário',
            onPressed: limparCampos,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 650,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // CABEÇALHO
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.school,
                              size: 38,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Cálculo de Média Acadêmica',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Informe os dados do aluno e as notas',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // DADOS DO ALUNO
                    _buildSectionTitle(
                      'Dados do Aluno',
                      Icons.person,
                    ),

                    const SizedBox(height: 15),

                    _buildTextField(
                      controller: _raController,
                      label: 'RA do Aluno',
                      hint: 'Digite o RA',
                      icon: Icons.badge_outlined,
                    ),

                    _buildTextField(
                      controller: _nomeController,
                      label: 'Nome do Aluno',
                      hint: 'Digite o nome completo',
                      icon: Icons.person_outline,
                    ),

                    _buildTextField(
                      controller: _disciplinaController,
                      label: 'Disciplina',
                      hint: 'Digite o nome da disciplina',
                      icon: Icons.menu_book_outlined,
                    ),

                    const SizedBox(height: 10),

                    // NOTAS
                    _buildSectionTitle(
                      'Notas',
                      Icons.grade_outlined,
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: _buildNotaField(
                            controller: _trabalhoController,
                            label: 'Trabalho',
                            icon: Icons.assignment_outlined,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _buildNotaField(
                            controller: _avaliacaoController,
                            label: 'Avaliação',
                            icon: Icons.fact_check_outlined,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // BOTÃO CALCULAR
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton.icon(
                        onPressed: calcularMedia,
                        icon: const Icon(Icons.calculate),
                        label: const Text(
                          'CALCULAR MÉDIA',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // RESULTADO
                    if (_media != null) _buildResultado(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.deepPurple,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Campo obrigatório';
          }

          return null;
        },
      ),
    );
  }

  Widget _buildNotaField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: '0 a 10',
        prefixIcon: Icon(icon),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Informe a nota';
        }

        final nota = double.tryParse(
          value.replaceAll(',', '.'),
        );

        if (nota == null) {
          return 'Nota inválida';
        }

        if (nota < 0 || nota > 10) {
          return 'Entre 0 e 10';
        }

        return null;
      },
    );
  }

  Widget _buildResultado() {
    final bool aprovado = _situacao == 'Aprovado';

    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const Text(
              'Resultado Final',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            CircleAvatar(
              radius: 42,
              backgroundColor: aprovado
                  ? Colors.green.withOpacity(0.12)
                  : Colors.red.withOpacity(0.12),
              child: Icon(
                aprovado
                    ? Icons.check_circle
                    : Icons.cancel,
                size: 50,
                color: aprovado
                    ? Colors.green
                    : Colors.red,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              _nomeController.text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              'RA: ${_raController.text}',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              _disciplinaController.text,
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),

            const Divider(height: 30),

            const Text(
              'Média Final',
              style: TextStyle(
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              _media!.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: aprovado
                    ? Colors.green
                    : Colors.red,
              ),
            ),

            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: aprovado
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                _situacao!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: aprovado
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}