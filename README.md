# [SUA MÚSICA] Head de App - Desafio Técnico

O projeto está organizado na seguinte estrutura:

- **base_app:** Responsável por rodar a aplicação. Único que conhece todos os Micro Apps da aplicação.
- **packages/dependencies:** Mantém centralizadas todas as dependências dos Micro Apps.
- **packages/core:** Mantém tudo que é compartilhado entre os Micro Apps (Widgets, mixins, entities, infra, etc).

Abaixo seguem informações sobre a estrutura do projeto, setup e outras considerações.

## **1. Arquitetura do projeto**

O projeto é dividido em packages, onde cada package implementa um Micro App, que segue a Clean Architecture.

![](./.images/clean.jpg)

Estrutura básica de pastas para os Micro Apps. Pode variar de acordo com a necessidade. Esta estrutura deve ser espelhada nos testes:

```yaml
/lib
  /domain
    /interfaces
    /entities
    /usecases
    /errors
  /data
    /interfaces
    /repositories
  /infrastructure
  /presentation
    /interfaces
    /views
    /validations
/internationalization
<main>.dart
```

### 1.1 Camadas

#### **Domain**

Essa camada é o core do Microapp. É onde são implementadas as entities e usecases, contendo, respetivamente, as regras
de negócio corporativas e regras de negócio da aplicação.

Nessa camada estarão definidas as ‘interfaces’ da camada data. Ocasionalmente existirão também algumas ‘interfaces’ da
camada infrastructure, como Navigation e DependencyManager.

Deve-se ter muito cuidado ao trabalhar nessa camada... Ela deve ter o mínimo de dependências externas possível. Quando
necessário adicionar algum package externo aqui, devem ser tomadas certas precauções, como:

- verificar o **real benefício** da sua utilização
- verificar o número de contribuintes desse package
- verificar se recebe atualizações constantemente
- verificar a sua popularidade/likes no pub.dev

#### **Data**

Na camada Data serão realizadas as chamadas a datasources locais ou externos e o tratamento dos dados de envio/recebimento por meio dos Repositories.

O tratamento dos dados, quando necessário, deve ser feito em classes "Model" específicas. Essas classes devem saber as
características dos dados sendo enviados ou recebidos (parse de JSON, parse de Model para Entity e vice-versa).

A comunicação com datasources externos/locais não será feita diretamente. Deve ser por ‘interface’ adapters. A
implementação dessa ‘interface’ (HttpClient, por exemplo) será recebida no repository através do seu constructor.

A definição dessas ‘interfaces’ adapters será localizada na própria camada data, por se tratar de uma dependência para a
sua execução. A sua implementação, no entando, deve ser feita em outra camada.

#### **Infrastructure**

Essa camada serve para isolar completamente o App de packages externos e suas particularidades. Internamente, o app trabalhará apenas com dados/classes locais, conhecidas por ele. Com a correta utilização dessa camada, se for necessário substituir um package por outro, o impacto tende a ser mínimo.

Como exemplo podemos pegar o caso comentado acima, onde os repositories da camada Data receberão as implementações de interface adapters. Esses adapters, como o nome já diz, adaptam uma classe externa para ser utilizada seguindo um padrão pré-definido no próprio App.

Podemos usar a comunicação HTTP como exemplo:

- Interface HttpClient:
  - Define como a comunicação deve ocorrer (métodos get, post, etc)
  - Define os tipos de retorno e exceptions lançadas, exemplo: HttpResponse e HttpError.
- Adapter da HttpClient - Implementação utilizando package Dio:
  - Define uma implementação da interface HttpClient, utilizando internamente o Dio.
  - Trata internamente as respostas de sucesso e erro do Dio e as converte para os tipos conhecidos: HttpResponse e HttpError.
  - Dessa forma, o Dio e suas particularidades não serão conhecidos e utilizados diretamente.

#### **Presentation**

Essa camada é responsável por tudo que tange a parte visual do App.

Nessa camada são definidos basicamente:

- Interfaces:
  - Contratos para a criação dos presenters e seus dados (state)
- Presenters:
  - Controlam o fluxo de dados da uma ou mais views
  - São implementados utilizando algum package externo, como Cubit/Bloc.
- Views/Components:
  - UI/componentes criados com Flutter
- Validations:
  - Form validations utilizados nas views
- Internationalization:
  - Classes para aplicação de i18n

#### **Main**

Essa camada está representada na estrutura acima como o arquivo `<main>.dart`. Nesse arquivo é feita toda a composição dos módulos/Micro Apps.

Isso significa que a camada Main conhece todas as outras camadas e será a responsável por montar toda a estrutura necessária para executar o Micro App. É essa camada que, por exemplo, fará a instanciação dos usecases e os injetará nos presenters.

Nesse projeto, essa camada é montada com a utilização do package flutter_modular.

Normalmente esse arquivo receberá o nome do Micro App que ele representa, por exemplo, para o Micro App de Onboarding existirá um arquivo `onboarding.dart` na pasta raiz do App.

### 1.2 Comunicação entre camadas

Segue abaixo um diagrama que visa mostrar como ocorre a comunicação entre as camadas. Ele exemplifica a implementação de uma feature de autenticação.

Imagine que a ação inicial ocorre na LoginPage, ao usuário informar seu e-mail e senha... Todo fluxo segue a partir daí.

Perceba as linhas destacadas em vermelho que cruzam as camadas: Essas linhas sempre indicam a direção central (Seguem em direção ao Domain) e são ligadas através de interfaces e suas implementações.

A interface que é definida em uma camada, acaba sendo implementada em outra, onde faz mais sentido.

![](./.images/commnnication.png)

### 1.3 Adicionando Micro Apps

Um Micro App pode ser adicionado através do comando:

```bash
flutter create -t package my_package
```

As únicas dependências que o Micro App pode ter são:

- local package: core
- local package: dependencies
- dev_dependencies

Exemplo:

```yaml
dependencies:
  core:
    path: ../core
  my_package:
    path: ../package/my_package

dev_dependencies:
  flutter_test:
    sdk: flutter

  flutter_lints: ^1.0.4
```

Cada Micro App deve seguir uma padronização:

1. Deve conter um arquivo `analysis_options.yaml` com as regras de análise/formatação do código. Mais detalhes na
   seção "Padronização e boas práticas".
3. Fazer sua própria injeção do `HttpAdapter` com os interceptors específicos.
4. Deve possuir suas próprias variáveis de ambiente, caso seja necessário.

Após sua criação, basta adicionar o novo package como dependência no `base_app`.

```yaml
dependencies:
  #...

  ### MICRO APPS ###
  onboarding:
    path: ../package/my_package
```

## **2. Setup**

Configurações do projeto (quase todas obrigatórias).

### 2.1 FVM

Projeto criado com uso do FVM (Flutter Version Management). **Recomenda-se** sua utilização para a fácil alternância entre versões do Flutter.

Manual de instalação e configuração nas IDEs [aqui.](https://fvm.app/docs/getting_started/installation)

### 2.2 Lefthook

Utilizado para configurar Git Hooks no projeto. Realiza algumas checagens antes de commits ou pushes.

Documentação com manual de instalação [aqui.](https://github.com/evilmartians/lefthook/blob/master/docs)

Após a instalação, acessar a raiz do projeto e executar:

```bash
lefthook install -f
```

### 2.3 Melos

O projeto adotou o uso do [Melos](https://melos.invertase.dev) para simplificar o gerenciamento do repositório, e o gerenciamento de cada Micro App.

Para começar, certifique-se de ter o Melos instalado. Caso ainda não o tenha, você pode instalá-lo utilizando o seguinte comando:

```bash
dart pub global activate melos
```

Após o check-out de uma branch com atualizações, recomenda-se limpar o projeto da seguinte forma:

```bash
melos clean
```

Em seguida, para garantir que as dependências estão corretamente configuradas, utilize o comando:

```bash
melos bootstrap
```

ou simplificadamente:

```bash
melos bs
```

Para obter mais informações sobre comandos úteis disponíveis no Melos, você pode executar:

```bash
melos --help
```

## **3. Executando o projeto**

Para executar, levar em consideração os flavors `dev`, `hml`, `preprod`, `preprod2` e `prod`.

Cada flavor possui um arquivo de configurações dentro da pasta `base_app/.env`.

Executar sempre da seguinte maneira:

```bash
cd base_app
flutter run -t lib/main-<flavor>.dart --flavor <flavor>
```

[Mais detalhes sobre a integração com AllowMe aqui](flutter_allowme_plugin/README.md)

### 3.1 Criando/editando flavors

Para a criação dos flavors, foi utilizado o package [flutter_flavorizr](https://github.com/AngeloAvv/flutter_flavorizr).

Seguir sua documentação para adição/edição dos flavors.

## **4. Testes**

Para manter a organização, cada arquivo de teste deve ser criado na mesma estrutura de pastas do arquivo sendo testado. Exemplo:

```bash
# Implementação
/lib
  /domain
    /usecases
      /remote_auth.dart

# Teste
/test
  /domain
    /usecases
      /remote_auth_test.dart
```

### 4.1 Padrões

Devem ser seguidos alguns padrões básicos na criação dos testes.

#### 4.1.1 Descrição do teste

Apresentar sempre uma descrição do comportamento esperado do teste.  
Como sugestão, pode-se iniciar sempre com `Deve` ou `Não deve`.

Exemplos:

- "Deve apresentar o componente com labels e valores iniciais"
- "Deve disparar evento X ao confirmar form"
- "Não deve permitir confirmação do form enquanto não estiver válido"
- "Deve disparar invalidCredentialsError ao realizar login com dados inválidos"

#### 4.1.2 Organização

Escrever os testes da maneira mais simples e direta possível. Lembrar que muitas vezes um teste será utilizado como "documentação" de uma feature complexa...

Sempre que possível, criar métodos auxiliares dentro do teste ou, se for algo global, no package `test_dependencies`.

Seguir sempre o padrão **AAA** (Arrange, Act e Assert).

- Arrange: Preparação do item sendo testado
- Act: Realiza alguma ação nesse componente para testar diferentes comportamentos
- Assert: Uma ou várias validações em cima do resultado gerado pelo Act

Sempre nomear o objeto sendo testado como `sut` (System Under Test). Essa padronização facilita bastante, visto que em um único arquivo de testes acabamos criando muitas variáveis auxiliares e isso pode acabar confundindo um pouco o leitor sobre o que realmente está sendo testado.

Segue um exemplo utilizando as indicações acima:

```dart
MeuComponente sut;
MyMock meuObjetoMock;

setUp(() {
  meuObjetoMock = createMock(); // Método auxiliar
  sut = createComponentePadrao(); // Método auxiliar
});

testWidgets('Deve disparar o evento X ao confirmar', (tester) async {
  // Arrange do sut
  await tester.pumpWidget(sut);

  // Act
  await tester.tap(find.byType(ConfirmButtonWidget));
  await tester.pump();

  // Assert
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
  verify(meuObjetoMock.eventoX()).called(1);
});
```

### 4.2 Mocks

Para os mocks de classes, será utilizado o [Mockito](https://pub.dev/packages/mockito). Na nova versão desse package é necessário utilizar o **build_runner** para a geração dos mocks. [Detalhes aqui](https://github.com/dart-lang/mockito/blob/master/NULL_SAFETY_README.md).

Exemplo de criação de mock para a classe `HttpServer`:

```dart
// File http_server_test.dart:
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';
import 'http_server.dart';
import 'http_server_test.mocks.dart';

@GenerateMocks([HttpServer])
void main() {
  test('test', () {
    var httpServer = MockHttpServer();
  });
}
```

Para gerar o arquivo `http_server_test.mocks.dart`, basta executar:

```bash
pub run build_runner build
```

### 4.3 Dados para testes

Quando estamos escrevendo testes, muitas vezes precisamos carregar os objetos com algumas informações. Para facilitar isso, foi adicionado ao projeto o package [faker](https://pub.dev/packages/faker).

Exemplo de utilização:

```dart
import 'package:faker/faker.dart';

main() {
  var faker = new Faker();

  faker.internet.email(); // francisco_lebsack@buckridge.com
  faker.internet.ipv6Address(); // 2450:a5bf:7855:8ce9:3693:58db:50bf:a105
  faker.internet.userName(); // fiona-ward
  faker.person.name(); // Fiona Ward
  faker.lorem.sentence(); // Nec nam aliquam sem et
}
```

## **5. Padronização e boas práticas**

Projeto configurado com o package [Flutter Lints](https://pub.dev/packages/flutter_lints).

As regras foram centralizadas no pacote `core`, no arquivo `linter_rules.yaml`.  
Cada package deve possuir um arquivo `analysis_options.yaml` com uma estrutura básica referenciando o package core (e podendo conter regras específicas):

```yaml
include: package:core/linter_rules.yaml
# Regras específicas do módulo abaixo do include...
```

### 5.1 Nome de classes e arquivos

#### **Domain**
Por padrão as entidades NÃO tem o sufixo "entity" (nem no arquivo e nem no nome da classe).
Por outro lado os usecases TEM o sufixo "usecase" no ARQUIVO e no nome da CLASSE. 
Ex: o arquivo get_user_usecase contém a classe GetUserUsecase
#### **Data**
Todos os arquivos model têm o sufixo "model" no nome do arquivo e no nome da classe
Ex: o arquivo user_model contém a classe UserModel

#### **Infrastructure**
#### **Presentation**

### 5.2 Commits

Deve ser mantida uma padronização quanto às mensagens de commits. Deve-se seguir o padrão especificado em [Conventional Commits.](https://www.conventionalcommits.org/pt-br/v1.0.0/)

É obrigatório sempre ter um tipo na mensagem de commit.  
_Essa validação é feita automaticamente pelo Lefthook no momento do commit._

```
<tipo>[escopo opcional]: <descrição>

[corpo opcional]

[rodapé(s) opcional(is)]
```

Prefixos aceitos: build, chore, ci, docs, feat, fix, perf, refactor, revert, style, test

## **6. Styleguide**

O projeto segue o styleguide definido [aqui.](https://www.figma.com/file/lEPN2fHbquDLmcSRdvgo60/Folha-de-componentes?node-id=2%3A44)

### 6.1. Configuração do Styleguide

Foram criados os temas **Light** e **Dark**. O tema **Light** é a base dos temas e é onde todas as configurações gerais foram setadas de acordo com o Styleguide.

O tema **Dark** é criado como uma cópia do **Light** alterando somente o que é necessário para o tema, como cores de fonte e background, facilitando alterações em propriedades gerais do estilo.

Também foram criadas extensions no ThemeData, ColorScheme e TextTheme para comportar as definições customizadas do StyleGuide que não existem por padrão nessas classes.

### 6.2 Utilização dos temas

Todo o Styleguide está definido dentro do ThemeData e pode ser acessado pelo Theme ou pela extension do BuildContext:

```dart
  // Acesso usando o Theme
  Theme.of(context)

  // Acesso pela extension do BuildContext
  context.theme
```

Na extension do BuildContext foram incluidos alguns atalhos para propriedades úteis do ThemeData

```dart
  // Atalho para o TextTheme do ThemeData
  context.textTheme

  //Acesso ao ColorScheme do ThemeData
  context.colorScheme
```

 
 
 
## **8. Módulos**

Documentação específica de cada módulo:

- [Onboarding](onboarding/README.md)


## **10. Variáveis de ambiente**

O Base App possui as variáveis de ambiente na pasta local `.env`.  
Essa pasta deve conter vários arquivos, **um arquivo por flavor**, seguindo a regra de sufixo abaixo:

```yaml
.env:
  - env.yaml: # Produção
  - env-dev.yaml: # Desenvolvimento
  - env-hml.yaml: # Homologação
```

Você pode alterar o valor dessas configurações alterando o valor diretamente no arquivo yaml.

## Configurações

Os nomes de todas as configurações estão definidos na classe `EnvDictionary`.
Sempre que uma configuração for alterada/editada/removida, esse arquivo deve ser atualizado.

### Configurações compartilhadas

Configurações que são comuns a vários Micro Apps e podem existir em vários arquivos `yaml`.

```yaml
# BFF Platform API - required
baseApi:
  url:
  xOrigin:
```
 # weather-app
