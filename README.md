# FiveM-Airdrops

-  Imagens

<div align="left">
<img src="https://media.discordapp.net/attachments/795622143433637889/1008866310756769842/unknown.png?width=580&height=478" width="400px" />
<img src="https://media.discordapp.net/attachments/795622143433637889/1008867550895013888/unknown.png?width=580&height=478" width="400px" />
<img src="https://media.discordapp.net/attachments/795622143433637889/1008873665250742333/unknown.png?width=565&height=478" width="400px" />
<img src="https://media.discordapp.net/attachments/795622143433637889/1008873747580735558/unknown.png?width=565&height=478" width="400px" />
</div>

# Descrição

```
Framework: VRPEX
Resmon: 0.01ms
```

<h3> Como Usar </h3>

Para usar basta extrair a pasta do script dentro da sua pasta de resources.
Após isso digite `ensure unity_airdrops` em seu server.cfg

Depois basta abrir o `server.lua` e ir na linha 118 para configurar seus itens!

<h3> Objetivo </h3>

O objetivo desse script é agregar de modo geral servidores que gostariam de usar o sistema de airdrops, sendo por comando
ou caindo de forma aleátoria de tempos em tempos.

<h3> Funcionalidades </h3>

O script pode ser executado tanto pelo comando /airdrop (quantidade) ou você pode predefinir um tempo aléatorio entre 30 e 60 minutos por exemplo
para os airdrops cairem de forma automatica. 

Ao se passar 30 minutos, se ainda estiver algum airdrop ele é deletado automaticamente.

Os itens que podem vir nos airdrops são totalmente configuráveis, tanto itens quanto dinheiro, armas e outros.

<h3> Atualizações Pendentes </h3>

Eu havia adicionado um prop para ser criado junto aos airdrops como mostra essa imagem abaixo, a parte de criar os props funcionou perfeitamente, porém, quando
você coleta o airdrop ou quando passa 30 minutos (os que não foram coletados são deletados automaticamente) as caixas não estão sumindo e eu não consegui arrumar,
então vou deixar para proximas atualizações, ou se alguém quiser corrigir eu atualizo aqui.

Deixei o código de criar os props comentado na linha 84 do `client.lua`

<div align="left">
<img src="https://media.discordapp.net/attachments/795622143433637889/1008867959101464698/unknown.png" width="200px" />
</div>

