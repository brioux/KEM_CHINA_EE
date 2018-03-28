$onecho > cmd.txt
I=db\ChinaGas.accdb

Q5=SELECT [marseg],'pipe',[Node],[price cap] FROM [province-price cap]
O5=build\data\NGpriceCap.inc

Q6=SELECT [type],[Asset Name],[Node],[marginal cost] FROM [Assets]
O6=build\data\NGomCost.inc

Q7=SELECT [type],[Asset Name],[Node],[Capital Total (MMUSD)] FROM [Assets]
O7=build\data\NGcapitalCost.inc

Q8=SELECT [firm],[assets],[Interest] FROM [partner share]
O8=build\data\NGpartner.inc

Q9=SELECT [Operator Name],[Start node],[End node],[Reported Capacity Gas BscmY] FROM [province-pipeline capacity]
O9=build\data\NGtransexist.inc

Q10=SELECT [start node],[end node],[length] FROM [provincial pipeline length]
O10=build\data\NGtransexistlen.inc

Q11=SELECT [operator],[node],[capacity bcmy] FROM [reg-cap]
O11=build\data\NGregasexist.inc

Q12=SELECT [type],[Asset Name],[Node],[horizon y] FROM [Assets]
O12=build\data\NGlifetime.inc

Q13=SELECT [Operator],[node],[Cap Cost USD MM] FROM [regasification-CAPEX]
O13=build\data\NGregasCapitalCost.inc

Q14=SELECT [segment],[node],[demand] FROM [provincial demand]
O14=build\data\NGdemand.inc

Q15=SELECT [Asset Name],[type 2],[node],[revised 2015] FROM [Assets]
O15=build\data\NGplateau.inc

Q16=SELECT [firm],[segment],'pipe',[node],[quota] FROM [province quota]
O16=build\data\NGquota.inc

Q17=SELECT [operator],[node],[capacity bcm] FROM [Liquefaction]
O17=build\data\NGliqueexist.inc

Q18=SELECT [operator],[node],[capital cost] FROM [Liquefaction]
O18=build\data\NGliqueCapitalCost.inc

Q19=SELECT [province],[production bcm] FROM [production 2015]
O19=build\data\NGprod2015.inc

$offecho
$call =mdb2gms.exe @cmd.txt
