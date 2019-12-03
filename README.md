# node-R-graph
R Graph displayed in a Node.js Express Web-UI


- [x] clone to $HOME directory and install requirements
```
cd ~/
git clone https://github.com/EvilRedHorse/node-R-graph.git
cd node-R-graph
npm install express shelljs
```


- [x] start redis-server instance on alternate port 6380

`redis-server --port 6380`


- [x] customize folders in config.json

`vim config.json`


- [x] add sia-host-info.sh to crontab

`crontab -l | { cat; echo "0 * * * * ~/node-R-Graph/test/scripts/sia-host-info.sh"; } | crontab -`


- [x] add ALL-json.sh to crontab

`crontab -l | { cat; echo "0 * * * * ~/node-R-Graph/test/scripts/ALL-json.sh"; } | crontab -`

- [x] start node instance on port 3030

```
cd test
node ../testStart.js
```

##### EDIT CRONTAB: crontab -e # then while in vim press the insert key to start typing, add the intervals (0 * * * * is hourly) , data granularity can be decreased by setting crontab to daily (0 0 * * *), add programs (sia-host-info.sh & All-json.sh) to load, leave an extra carriage return at the end, then press the esc key, type :qw and press the enter key to exit. You can google vim or man vim and/or change your editing env for crontab to your favourite editor.

## USAGE:

#### will access sia host/storage info from the api and cache info to redis linked-lists
`sia-host-info.sh`

#### create 2D json matrix from redis linked-lists variable (y-axis) & date since epoch in seconds (x-axis)
##### - rsyncs .json to remote folder
`sia-host-info-json.sh [Y-AXIS] [X-INTERVALS]`

#### feeds redis linked-lists into XY json 2D matrix - wraps ALL known host/storage variable through sia-host-info-json.sh
##### - update/rsync "json" folder with ALL json matrices
`ALL-json.sh`

#### graph a .ps from .json 2D matrix
`R/runXY.r [folder/file_name.ps] [XY_matrix.json]`

#### loops R/runXY.r by feeding .json from ALL sia host/storage linked-lists 
##### - an individual or array of [Y-AXIS] linked lists can also be fed in, defaults to ALL
##### - each .ps is converted to .svg and .ps removed.
##### - creates $MEM/graphs
##### - $MEM/graphs folder rsyncs to $NODE "graphs" folder 
`graph.sh [Y-AXIS]`



I :heart: SiaPrime Coin (SCP): `f2e15fc822761f083db8376ea3b151d6f398abc951ee102b40a20839eeaf531a6b432535b5f6`
