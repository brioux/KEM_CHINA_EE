$onecho > cmd.txt
I=db\ChinaGas.accdb

Q1=SELECT [Asset Name] FROM [Assets]
O1=build\data\NGs.inc

Q2=SELECT [node] FROM [province]
O2=build\data\r.inc

Q3=SELECT [Start node],[End node],[connection] FROM [provincial pipeline length]
O3=build\data\NGconnect.inc

Q4=SELECT [type 2],[Asset Name],[Node],[NGts] FROM [Assets]
O4=build\data\NGts.inc

Q5=SELECT [Asset Name],[associated] FROM [Assets]
O5=build\data\NGa.inc

Q6=SELECT [Asset Name],[Status] FROM [Assets]
O6=build\data\NGstatus.inc

Q7=SELECT [node] FROM [Province] WHERE [LNG Imports]
O7=build\data\NGrILng.inc

Q8=SELECT [node] FROM [Province] WHERE [Pipeline Imports]
O8=build\data\NGrIPipe.inc



$offecho
$call =mdb2gms.exe @cmd.txt

$ontext
data input
*---------Done--------Done--------Done-------Done--------Done--------Done------------
    NGpriceCap(NGm,NGw,r)  price caps
    NGomCost(NGt,NGs,r) marginal production cost
    NGcapitalCost(NGt,NGs,r) annualzied investment cost for each field
    NGpartner(NGi,NGs) partern shares in each asset NGs
    NGtransexist(NGi,r,rr) pipeline capacity
    NGregasexist(NGi,r) natural gas regasification infrastructure
    NGhorizon(NGt,NGs,r) production horizon for each field
    NGtransOM    marginal transportation cost
    NGimportPrice(NGw,r) natural gas import price
    NGtransTariff(NGw,r,rr) transportation tariffs for pipeline
    NGregasCapitalCost(NGi,r)
    NGdemand(NGm,r) fixed gas demand in each region
    NGfuelpflag(NGm,NGw,r) Natural gas wholesale market pricing rule flag
    NGquota(NGi,NGm,NGW,r) supply quotas when price cap is binding
    NGtransTariff(NGw,r,rr)

$offtext

