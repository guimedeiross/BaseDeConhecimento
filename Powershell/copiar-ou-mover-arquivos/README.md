# copiar-ou-mover-arquivos

Script que usa o Get-child item para procurar arquivos que vc deseja copiar ou mover para alguma pasta especifica e efetua a operação.

Para usar é muito facil, vc edita o Source no script para a pasta que vc quer procurar por arquivos e o Destination para pasta onde vc que copiar ou mover tais arquivos.
Além disso vc pode colocar a extensão do arquivo que deseja copiar ou mover, se usar o Filter, usa apenas uma extensão, se usar o Include, pode colocar mais extensões, lembrando que se for usar o include tem que alterar o source, exemplo:
Procura com Filter: C:\users -filter *.txt
Procura com Include: C:\users\* -Include *.txt,*.pdf