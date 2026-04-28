import 'package:flutter/material.dart';
import 'cores_app.dart';

class TelaRegistrarTransacao extends StatefulWidget {
  const TelaRegistrarTransacao({super.key});

  @override
  State<TelaRegistrarTransacao> createState() => _TelaRegistrarTransacaoState();
}

class _TelaRegistrarTransacaoState extends State<TelaRegistrarTransacao> {
  bool _isGasto = true;

  // Controles de Categoria
  String _categoriaGasto = 'Comida';
  String _categoriaInvest = 'Ações';

  // Controlador pro Valor (fazer o cálculo automático do rendimento dps)
  final _valorController = TextEditingController();

  @override
  void dispose() {
    _valorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoresApp.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: CoresApp.cardBackground,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.white),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.receipt_long, color: CoresApp.yellow, size: 20),
            SizedBox(width: 8),
            Text("Registrar Transação", style: TextStyle(color: CoresApp.yellow, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        actions: const [
          Icon(Icons.more_horiz, color: Colors.white),
          SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- TOGGLE: GASTO vs INVESTIMENTO ---
            Container(
              decoration: BoxDecoration(
                color: CoresApp.cardBackground,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isGasto = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _isGasto ? CoresApp.yellow : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.sports_esports_outlined, size: 18, color: _isGasto ? Colors.black : CoresApp.textcinza),
                            const SizedBox(width: 8),
                            Text("Gasto", style: TextStyle(fontWeight: FontWeight.bold, color: _isGasto ? Colors.black : CoresApp.textcinza)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isGasto = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !_isGasto ? const Color(0xFF5A4C8C) : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.trending_up, size: 18, color: !_isGasto ? Colors.white : CoresApp.textcinza),
                            const SizedBox(width: 8),
                            Text("Investimento", style: TextStyle(fontWeight: FontWeight.bold, color: !_isGasto ? Colors.white : CoresApp.textcinza)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // --- INPUT DE VALOR (Dinâmico) ---
            Text(_isGasto ? "VALOR" : "VALOR INVESTIDO", style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: CoresApp.cardBackground,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: CoresApp.textcinza.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0, right: 8.0),
                        child: Text("R\$", style: TextStyle(color: CoresApp.textcinza, fontSize: 16)),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _valorController,
                          style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            hintText: "0,00",
                            hintStyle: TextStyle(color: Colors.white, fontSize: 40),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Text("Toque para digitar o valor", style: TextStyle(color: CoresApp.textcinza, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // ========================================================
            // SESSÃO CONDICIONAL: O CONTEÚDO MUDA SE FOR GASTO OU INVEST
            // ========================================================
            if (_isGasto) ...[
              // === VISÃO DE GASTO ===
              const Text("CATEGORIA", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
              const SizedBox(height: 15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoriaCircle("🍔", "Comida", _categoriaGasto == 'Comida'),
                    _buildCategoriaCircle("🚌", "Trans.", _categoriaGasto == 'Trans.'),
                    _buildCategoriaCircle("🎮", "Lazer", _categoriaGasto == 'Lazer'),
                    _buildCategoriaCircle("📚", "Estudo", _categoriaGasto == 'Estudo'),
                    _buildCategoriaCircle("💊", "Saúde", _categoriaGasto == 'Saúde'),
                    _buildCategoriaCircle("🏠", "Moradia", _categoriaGasto == 'Moradia'),
                    _buildCategoriaCircle("✈️", "Viagem", _categoriaGasto == 'Viagem'),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              _buildInputLiso(Icons.edit, "Descrição (ex: almoço no restaurante...)"),
              const SizedBox(height: 15),
              _buildInputLiso(Icons.calendar_today, "Data — hoje, 14/04/2026"),
              const SizedBox(height: 15),
              _buildInputLiso(Icons.location_on_outlined, "Estabelecimento (opcional)", colorIcon: const Color(0xFFFF6B6B)),

            ] else ...[
              // === VISÃO DE INVESTIMENTO ===
              const Text("TIPO DE INVESTIMENTO", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
              const SizedBox(height: 15),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoriaPill("📈", "Ações", _categoriaInvest == 'Ações'),
                    _buildCategoriaPill("💰", "Renda Fixa", _categoriaInvest == 'Renda Fixa'),
                    _buildCategoriaPill("🪙", "Cripto", _categoriaInvest == 'Cripto'),
                    _buildCategoriaPill("🏛️", "Tesouro", _categoriaInvest == 'Tesouro'),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              _buildInputLiso(Icons.edit, "Descrição (ex: PETR4, CDB Itaú...)"),
              const SizedBox(height: 15),
              _buildInputLiso(Icons.calendar_today, "Data — hoje, 14/04/2026"),
              const SizedBox(height: 15),
              _buildInputLiso(Icons.account_balance, "Corretora ou banco (opcional)", colorIcon: const Color(0xFF38E09E)),
              const SizedBox(height: 25),

              // Card de Retorno Esperado
              const Text("RETORNO ESPERADO", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: CoresApp.cardBackground,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: CoresApp.textcinza.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Rentabilidade estimada", style: TextStyle(color: Colors.white, fontSize: 14)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF38E09E).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text("+12% a.a.", style: TextStyle(color: Color(0xFF38E09E), fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Em 12 meses, seu R\$0 vira", style: TextStyle(color: CoresApp.textcinza, fontSize: 12)),
                        Text("R\$ 0,00", style: TextStyle(color: CoresApp.yellow, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Text("Simulação baseada no tipo de ativo selecionado", style: TextStyle(color: CoresApp.textcinza, fontSize: 10)),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 25),

            // --- COMPROVANTE (Comum para ambos) ---
            const Text("COMPROVANTE", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.1)),
            const SizedBox(height: 5),
            if (_isGasto) const Text("Foto ou PDF — o app extrai os dados automaticamente!", style: TextStyle(color: CoresApp.textcinza, fontSize: 12)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildComprovanteCard(Icons.camera_alt_outlined, "Tirar Foto", _isGasto ? "Nota ou recibo" : "Nota de corretagem")),
                const SizedBox(width: 15),
                Expanded(child: _buildComprovanteCard(Icons.insert_drive_file_outlined, "Enviar PDF", _isGasto ? "Extrato ou fatura" : "Extrato ou informe")),
              ],
            ),

            // Exemplo de Nota Anexada (Aparece no Gasto)
            if (_isGasto) ...[
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF162521),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFF38E09E).withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Color(0xFF1E3A2F), shape: BoxShape.circle),
                      child: const Icon(Icons.receipt, color: Color(0xFF38E09E), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("nota_restaurante.jpg", style: TextStyle(color: Color(0xFF38E09E), fontWeight: FontWeight.bold, fontSize: 14)),
                          Text("Extraído: R\$42,50 · Comida · 14/04", style: TextStyle(color: Color(0xFF38E09E), fontSize: 12)),
                        ],
                      ),
                    ),
                    const Icon(Icons.close, color: Color(0xFF38E09E), size: 20),
                  ],
                ),
              ),
            ],

            // Exemplo de Bônus (Aparece no Investimento)
            if (!_isGasto) ...[
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: CoresApp.cardBackground,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: CoresApp.yellow.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.flash_on, color: CoresApp.yellow, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Bônus de herói investidor!", style: TextStyle(color: CoresApp.yellow, fontWeight: FontWeight.bold, fontSize: 14)),
                          Text("Investimentos dão XP em dobro hoje", style: TextStyle(color: CoresApp.textcinza, fontSize: 12)),
                        ],
                      ),
                    ),
                    const Text("+100 XP", style: TextStyle(color: CoresApp.yellow, fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 35),

            // --- BOTÃO REGISTRAR E GANHAR XP ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Lógica de salvar a transação
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.sports_esports, color: Colors.black),
                label: const Text(
                    "Registrar e Ganhar XP",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black)
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CoresApp.yellow,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  // Ícone Circular (Para Gastos)
  Widget _buildCategoriaCircle(String emoji, String titulo, bool isSelecionado) {
    return GestureDetector(
      onTap: () => setState(() => _categoriaGasto = titulo),
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: CoresApp.cardBackground,
                shape: BoxShape.circle,
                border: Border.all(color: isSelecionado ? CoresApp.yellow : Colors.transparent, width: 2),
              ),
              child: Center(child: Text(emoji, style: const TextStyle(fontSize: 20))),
            ),
            Text(
              titulo,
              style: TextStyle(
                color: isSelecionado ? CoresApp.yellow : CoresApp.textcinza,
                fontSize: 10,
                fontWeight: isSelecionado ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Ícone em Pílula (Para Investimentos)
  Widget _buildCategoriaPill(String emoji, String titulo, bool isSelecionado) {
    return GestureDetector(
      onTap: () => setState(() => _categoriaInvest = titulo),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelecionado ? const Color(0xFF5A4C8C) : CoresApp.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelecionado ? const Color(0xFFCC1AFE) : Colors.transparent),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 8),
            Text(
              titulo,
              style: TextStyle(
                color: isSelecionado ? Colors.white : CoresApp.textcinza,
                fontWeight: isSelecionado ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Input Text Estilo "Liso"
  Widget _buildInputLiso(IconData icone, String hint, {Color colorIcon = CoresApp.textcinza}) {
    return Container(
      decoration: BoxDecoration(
        color: CoresApp.cardBackground,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: CoresApp.textcinza.withOpacity(0.2)),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: CoresApp.textcinza, fontSize: 14),
          prefixIcon: Icon(icone, color: colorIcon, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  // Card de Anexo (Comprovante)
  Widget _buildComprovanteCard(IconData icone, String titulo, String subtitulo) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: CoresApp.cardBackground,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: CoresApp.textcinza.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icone, color: CoresApp.textcinza, size: 30),
          const SizedBox(height: 10),
          Text(titulo, style: const TextStyle(color: CoresApp.yellow, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Text(subtitulo, style: const TextStyle(color: CoresApp.textcinza, fontSize: 10)),
        ],
      ),
    );
  }
}