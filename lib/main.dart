import 'package:flutter/material.dart';

void main() {
  runApp(const SistemaAcademicoApp());
}

class AppColors {
  static const Color primary = Color(0xFF6C4DF6);
  static const Color primaryDark = Color(0xFF4B2FD1);
  static const Color background = Color(0xFFF4F4FB);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF1C1B2E);
  static const Color textSecondary = Color(0xFF6E6B85);
  static const Color success = Color(0xFF12B76A);
  static const Color danger = Color(0xFFF04438);
}

class SistemaAcademicoApp extends StatelessWidget {
  const SistemaAcademicoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistema cálculo IMC',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
        ),
        scaffoldBackgroundColor: AppColors.background,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF7F7FC),
          hintStyle: const TextStyle(color: Color(0xFFB4B2C7)),
          prefixIconColor: AppColors.textSecondary,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.danger),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.danger, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
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

  final _nomeController = TextEditingController();
  final _pesoController = TextEditingController();
  final _alturaController = TextEditingController();

  double? _imc;
  String? _situacao;

  @override
  void dispose() {
    _nomeController.dispose();
    _pesoController.dispose();
    _alturaController.dispose();

    super.dispose();
  }

  void calcularIMC() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final double peso =
        double.parse(_pesoController.text.replaceAll(',', '.'));

    final double altura =
        double.parse(_alturaController.text.replaceAll(',', '.'));

    final double imc = peso / (altura * altura);

    setState(() {
      _imc = imc;
      _situacao = classificarIMC(imc);
    });
  }

  String classificarIMC(double imc) {
    if (imc < 18.5) return 'Abaixo do peso';
    if (imc < 25) return 'Peso normal';
    if (imc < 30) return 'Sobrepeso';
    if (imc < 35) return 'Obesidade grau I';
    if (imc < 40) return 'Obesidade grau II';
    return 'Obesidade grau III';
  }

  Color corIMC(double imc) {
    if (imc < 18.5) return const Color(0xFFF79009);
    if (imc < 25) return AppColors.success;
    if (imc < 30) return const Color(0xFFF79009);
    return AppColors.danger;
  }

  void limparCampos() {
    _formKey.currentState?.reset();

    _nomeController.clear();
    _pesoController.clear();
    _alturaController.clear();

    setState(() {
      _imc = null;
      _situacao = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // DADOS DA PESSOA
                          _buildCard(
                            title: 'Dados da Pessoa:',
                            icon: Icons.person_outline,
                            children: [
                              _buildTextField(
                                controller: _nomeController,
                                label: 'Nome da Pessoa',
                                hint: 'Digite o nome',
                                icon: Icons.person_outline,
                              ),
                              _buildTextField(
                                controller: _pesoController,
                                label: 'Peso da pessoa (KG)',
                                hint: 'Digite o peso',
                                icon: Icons.fitness_center_outlined,
                                numerico: true,
                              ),
                              _buildTextField(
                                controller: _alturaController,
                                label: 'Altura da pessoa (M)',
                                hint: 'Digite a altura',
                                icon: Icons.height_outlined,
                                isLast: true,
                                numerico: true,
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          _buildActions(),

                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),
                            transitionBuilder: (child, animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: SizeTransition(
                                  sizeFactor: animation,
                                  axisAlignment: -1,
                                  child: child,
                                ),
                              );
                            },
                            child: _imc == null
                                ? const SizedBox.shrink()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 24),
                                    child: _buildResultado(),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 34),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.monitor_weight_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sistema de IMC',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Índice de Massa Corporal',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Limpar formulário',
                onPressed: limparCampos,
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.15),
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          const Text(
            'Informe seu peso e altura para\ncalcular o IMC.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.5,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(title, icon),
          const SizedBox(height: 18),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
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
    bool isLast = false,
    bool numerico = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
      child: TextFormField(
        controller: controller,
        textInputAction:
            isLast ? TextInputAction.done : TextInputAction.next,
        keyboardType: numerico
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Campo obrigatório';
          }

          if (numerico) {
            final numero = double.tryParse(value.replaceAll(',', '.'));
            if (numero == null) {
              return 'Valor inválido';
            }
            if (numero <= 0) {
              return 'Deve ser maior que zero';
            }
          }

          return null;
        },
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: calcularIMC,
          child: const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calculate_rounded, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'CALCULAR IMC',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultado() {
    final Color cor = corIMC(_imc!);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cor.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: cor.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 6),
              const Text(
                'Resultado',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: cor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.monitor_weight_outlined,
              size: 52,
              color: cor,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            _nomeController.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'Peso ${_pesoController.text} kg  ·  Altura ${_alturaController.text} m',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(height: 1),
          ),

          const Text(
            'SEU IMC',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            _imc!.toStringAsFixed(2),
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: cor,
              height: 1,
            ),
          ),

          const SizedBox(height: 16),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: (_imc! / 40).clamp(0.0, 1.0)),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOut,
              builder: (context, value, _) {
                return LinearProgressIndicator(
                  value: value,
                  minHeight: 10,
                  backgroundColor: cor.withOpacity(0.12),
                  valueColor: AlwaysStoppedAnimation(cor),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
            decoration: BoxDecoration(
              color: cor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 18,
                  color: cor,
                ),
                const SizedBox(width: 8),
                Text(
                  _situacao!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: cor,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}