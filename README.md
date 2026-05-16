# 🛡️ Savings

Bem-vindo ao repositório do **Savings**, um aplicativo de gestão financeira que transforma o controle dos seus gastos em uma jornada interativa e gamificada.

Desenvolvido com **Dart e Flutter** para o projeto acadêmico UPX, o aplicativo ajuda o usuário a categorizar despesas (Fixos, Variáveis, Pessoais e Outros) e oferece insights inteligentes sobre sua saúde financeira por meio do nosso "Oráculo Financeiro".

## 🎯 Principais Funcionalidades
* **Dashboard Interativo**: Acompanhe o saldo disponível, seu nível atual e missões financeiras ativas.
* **Análise de Gastos**: Visualização de despesas através de gráficos de pizza interativos (utilizando a biblioteca `fl_chart`), com detalhamento (Drill-down) por categoria.
* **Oráculo Financeiro**: Sistema de inteligência que calcula o comprometimento da renda e fornece dicas de educação financeira em tempo real.

## 🛠️ Pré-requisitos
Antes de iniciar, certifique-se de ter as seguintes ferramentas configuradas em seu ambiente de desenvolvimento:
* [Flutter SDK](https://docs.flutter.dev/get-started/install)
* Emulador Android/iOS configurado (ou um dispositivo físico conectado)
* Git

## 🚀 Instruções de Execução (Front-end)
Siga os passos abaixo para compilar e executar o aplicativo localmente:

1. **Clone o repositório:**
```bash
git clone https://github.com/Saturkkj/savings_front.git
```
2. **Acesse a pasta do projeto:**
```bash
cd savings_front
```
3. **Instale as dependências do Flutter:**
```Bash
flutter pub get
```
4. **Execute o aplicativo:**
```bash
flutter run
```
## 📱 Rodando no Celular Físico (Via USB)
Quer testar o app direto na sua mão em vez de usar o emulador? O esquema é liberar o desenvolvedor no seu aparelho Android:

**1. Desbloqueando a Skill de Desenvolvedor:**
* Vá nas **Configurações** do seu celular > **Sobre o telefone**.
* Toque cerca de 7 vezes seguidas em **Versão da MIUI/SO** (ou Número da Versão/Build) até aparecer a mensagem "Você agora é um desenvolvedor!".

**2. Ativando a Depuração USB:**
* Volte para as Configurações e acesse **Configurações Adicionais** > **Opções do Desenvolvedor** (ou Sistema > Opções do Desenvolvedor).
* Ative a chave **Depuração USB**. Em alguns aparelhos, é necessário ativar também a opção **Instalar via USB**.

**3. Conectando os Mundos:**
* Conecte o cabo USB no PC e no celular.
* Um pop-up de segurança vai aparecer na tela do seu aparelho perguntando "Permitir depuração USB?". Marque a caixa de confiança e dê **OK**.

**4. Instalando o App:**
* No terminal da sua IDE, rode `flutter devices` para confirmar que o PC reconheceu seu aparelho.
* Mande o `flutter run` e aguarde o app ser instalado!
