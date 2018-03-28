sets
*    NGf(f) gas types                     /methane,ethane/
    NGi naturagl gas supply firms        /CNOOC,CNPC,Other,Sinopec/
    NOC(NGi) /CNPC,CNOOC,Sinopec/
    CNPC(NGi) /CNPC/
    NGt                                  /conventional, unconventional, offshore, CBM, CMM/
    NGw gas deliver mode  /pipe, lng/
    lng(NGw) /lng/
    pipe(NGw) /pipe/
    NGm natural gas market segments      /CityGate, Direct, Chemical/
    NGmFixed(NGm) market segments with fixed demand
    CityGate(NGm) /CityGate/
    r   region (province)
        /
$INCLUDE build/data/r.inc
        /
    r_offshore(r) /Xihu,Bozhong/
    NGrILng(r) import nodes for LNG
        /
$INCLUDE build/data/NGrILNG.inc
        /
    NGrIPipe(r) Import nodes for pipelines
        /
$INCLUDE build/data/NGrIPipe.inc
        /
    NGiwR(NGi,NGw,r) import regions by gas type and firm
    NGiw(NGi,NGw) imports with contracts
    NGs supply step or asset in each region
        /
$INCLUDE build/data/NGs.inc
        /
    NGsD(NGs) Assets still in appraisal Discovery prospect etc
    NGts(NGt,NGs,r) intersection of gas type and assets
        /
$INCLUDE build/data/NGts.inc
        /
    NGtw(NGi,NGt,NGw) intersection of gas type and state (only select types can be liquifeid by regulation)
    NGstatus(NGs) production status of each asset
*1:producing; 2:Prod, improved recov; 3:appraising; 4:discovery; 5:developing; 6:Intermittent prod)
         /
$INCLUDE build/data/NGstatus.inc
         /
;
    NGmFixed(NGm) = yes;
    NGsD(NGs) = no;
alias
    (r,rr), (NGi,NGii), (NGw,NGww), (NGs,NGss), (NGt,NGtt), (NGm,NGmm)
;
sets
    NGconnect(r,rr) interegional connections
         /
$INCLUDE build/data/NGconnect.inc
         /
    NGc(NGi,NGw,NGii,r,rr) interegional connections by firming accessing infrastructure (NGi) pipeline ownership (NGii) and delivery mode
;

    NGconnect(rr,r)$NGconnect(r,rr) = yes;
* all firms can access pipelines owned by other firms
*     NGc(NGii,'pipe',NGi,r,rr)$NGconnect(r,rr) = yes
    NGc(NGii,'pipe',NGi,r,rr)$NGconnect(r,rr) = yes
;
*  firms can only move lng using  own equipment (purchased/rented/leased)
    NGc(NGi,'lng',NGi,r,rr)$NGconnect(r,rr)  = yes
;

*all firms produce gas for pipeline
    NGtw(NGi,NGt,pipe) = yes
;
* Domestic LNG production limited to other producers
    NGtw(NGi,'unconventional',lng) = yes
;
    NGtw(NGi,'CBM',lng) = yes
;
    NGtw(NGi,'CMM',lng) = yes
;

   NGts(NGt,'Beijing-CEIC','Beijing') = yes
;
   NGts(NGt,'Shanxi-CEIC','Shanxi') = yes
;
   NGts(NGt,'Baoyue','Guangdong') = yes
;
   NGts(NGt,'Huizhou 21-1/27-1','Guangdong') = yes
;
   NGts(NGt,'Panyu 30-1','Guangdong') = yes
;
   NGts(NGt,'Liwan Gas Project','Guangdong') = yes
;
