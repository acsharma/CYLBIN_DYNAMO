;;;; Locate a file listing the hourly header files, and NHOURS

;   EXPNAME          : experiment name (string).
;   FILENAMELIST     : Full file path to vadlist. (string)
;   PSFILE_STUB      : Desired filename for output plots. (string)
;   SWAP_ENDIAN_FLAG : If set, swap byte ordering when reading in data. If the message : "Negative
;                histogram values" pops up, it is a sign that this keyword should be set.
exp_name='CYLBIN_smartr_dummy'
FilenameList = 'file_list_smartr_cruise_all.txt'
PSFILE_STUB = 'CYLBIN_smartr_dummy'

NEED_TO_SWAP_ENDIAN_FLAG = 0
HISTS_ARE_SHORTINT = 0 ;;; a legacy thing - zero from now on

;;;;;;;;;;;;;;;;;;; CYLBIN spatial grid definition

        naz =24    ; 24 x 
        daz =360./naz  ; 15 degrees */
        nr  =12    ; 12 x
        dr  =8000 ; meters for Mapes and Lin deep convective stuff
        nz  =36   ; 36 x
        dz  =500  ; meters, Mapes -Lin deep choice */
        
        
;;;; Define spatial coordinate arrays

	az=(findgen(naz)+0.5)*daz
	r=(findgen(nr)+0.5)*dr*0.001
	z=(findgen(nz)+0.5)*dz*0.001

;;; pressure coordinate rebinning array parameters

        np = 19
        dp=-50.0
        p= (1000+dp/2) + findgen(np)*dp

;;; a pressure sounding p(z) is needed to convert z data to p grid
;;; COARE mean, roughly every 50 mb centered in layers
;975.000     0.224252      25.6710      21.7421    0.0170455  351.306
;920.000     0.733122      22.1706      18.1332    0.0143827  345.170
;865.000      1.26671      19.2652      14.3385    0.0119631  340.765
;815.000      1.77659      16.6987      11.1533    0.0102777  338.626
;770.000      2.25839      14.3907      8.11917   0.00885321  337.215
;725.000      2.76445      11.8202      5.12623   0.00763869  336.374
;685.000      3.23671      9.24026      2.51637   0.00671893  336.001
;645.000      3.73227      6.40206   -0.0237790   0.00593812  336.009
;605.000      4.25373      3.42582     -2.84827   0.00513834  336.095
;570.000      4.73386     0.765274     -5.32802   0.00452306  336.652
;535.000      5.23917     -1.91628     -8.31752   0.00382597  337.229
;500.000      5.77283     -4.81654     -11.7773   0.00311171  337.818
;470.000      6.25545     -7.56800     -14.7770   0.00259268  338.602
;440.000      6.76411     -10.5570     -18.0809   0.00210045  339.501
;415.000      7.21013     -13.2472     -21.1395   0.00171169  340.350
;385.000      7.77509     -16.8425     -24.9751   0.00131290  341.512
;360.000      8.27355     -20.1881     -28.4294   0.00102293  342.538
;335.000      8.80019     -23.9448     -32.3943  0.000754631  343.472
;315.000      9.24407     -27.2584     -35.8913  0.000569170  344.218
;295.000      9.71026     -30.8756     -39.5088  0.000420741  344.995
;275.000      10.2012     -34.8196     -40.0000  0.000297917  345.767
;255.000      10.7200     -39.1196     -40.0000  0.000203965  346.548
;235.000      11.2701     -43.7975     -40.0000  0.000133159  347.339
;220.000      11.7060     -47.5700     -40.0000  9.32016e-05  347.949
;200.000      12.3228     -52.9454     -40.0000  5.48021e-05  348.858
;185.000      12.8160     -57.2447     -40.0000  3.52091e-05  349.655
;170.000      13.3396     -61.7852     -40.0000  2.14807e-05  350.600
;160.000      13.7079     -64.9432     -40.0000  1.50048e-05  351.360
;145.000      14.2938     -69.8667     -40.0000  8.41651e-06  352.794
;135.000      14.7101     -73.1416     -40.0000  5.69461e-06  354.249
;125.000      15.1506     -76.2820     -40.0000  3.88800e-06  356.422
;110.000      15.8670     -80.2081     -40.0000  2.71297e-06  362.288
;105.000      16.1239     -81.2021     -40.0000  2.55594e-06  365.238
;95.0000      16.6715     -82.5760     -40.0000  3.07783e-06  373.134
;85.0000      17.2753     -81.9068     -40.0000  5.71589e-06  386.535
;80.0000      17.6048     -79.7921     -40.0000  6.77028e-06  397.636

;;;; Should be NZ values (36)
psond = [ $
975.000,920.000,865.000,815.000,770.000, $
725.000,685.000,645.000,605.000,570.000, $
535.000,500.000,470.000,440.000,415.000, $
385.000,360.000,335.000,315.000,295.000, $
275.000,255.000,235.000,220.000,200.000, $
185.000,170.000,160.000,145.000,135.000, $
125.000,110.000,105.000,95.0000,85.0000,80.0000]
;;;        psond = 1000. *exp(-z/8.) 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Histogram bin spacings

;;; dBZ histogram
        ndbz =66   ; number of dbZ bins, bad(0) and 1 (or less) to 65 (or greater) 
						 
;;; dBZ array
        dbz =findgen(ndbz)

;;; FOr Vr and Width, fix the widths and allocate plenty of bins
        dvr  =4    ; m/s  width of Vr bins in histograms
        dwid =0.5  ; m/s width of spectral width bins
        nvr  = 20   ; number of Vr bins - plenty (excess
        nwid = 40   ; number of spec width bins

;;; /* SDZ is the spatial (along-beam) stdev of dBZ for con-strat discrimination */   
;;;   #define LENGTH_SDZ  5000   /* meters - boxcar window for stdev(dBZ) */
        dSDZ = 1 
        NSDZ = 36       

;;; Width array needed, but not Vr array
	wid=(findgen(nwid)+0.5)*dwid
	SDZ_values=(findgen(nSDZ)+0.5)*dSDZ
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; Need the nyquist velocity. Could hard-wire, or query header
; HEADER VARIABLES
; 0 - minutes into hour
; 1,2 lat,lon
; 3 nsweeps
;      header[4]=rng_first_bin;
;      header[5]=bin_space;
;      header[6]=pw;
;      header[7]=prf;
;      header[8]=wave;
;      header[9]=nyq_vel;
; ex      28.0000     -85.0000     -20.0000      4.00000      125.000      125.000
; ex     0.500346      1999.00    0.0535938      26.7835

headfile = ''
openr, 1, FilenameList
readf, 1, headfile
close, 1

header= fltarr(10)
openr, 1, headfile, swap_endian=NEED_TO_SWAP_ENDIAN_FLAG ;, /compress
while not eof(1) do begin
   readu,1,header
   
endwhile
close, 1
print, 'HEADER SAMPLE: ',header

;;; Grab the wanted thing
        vnyq = header[9] ;;; Nyquist velocity

print, "** vnyq = ", vnyq

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Unfolding and plotting parameters - adjust, optimize

;;; STAGE 1 parametters: What is the error assigned to Vr speckle? 
;;; It should be huge, for true noise (no data) so that this noise cannot
;;; impact the VAD curve fit hardly at all. In AMMA, the speckle has a
;;; U-shaped histogram, for unclear reasons. Stratospheric data (pure
;;; noise presumably) has a stdev about 6.5 for example. Relative
;;; unfolding thus tends to make the mean Vr be near +/- Vnyq (ends of
;;; the U-shaped histogram), so when we have a meanVr above say 10 m/s
;;; (Vnyq is 13 and bin width is 4 m/s), then let's inflate stdev to 50.
;;;vr_speckle_stdev_floor = 6 ;; check with std 
;;;LIKELY_VR_FLOOR_SPECKLE = 10 ;; m/s (abs value), near Nyquist of 12.9 for AMMA U-shaped hist

;;; We have improved the de-spekling part of the algorithm with following thresholds ;;;
;;;; Nov 09, 2015 ;;;;;

inflated_speckle_stdev = 99.9 ;;
flathist_thresh=1.1; Speckle correction: ratio of stdev to the mean of the velocity historam
nobs_min=8 ;;; min # of observations in vr histogram to trust the doppler velocity

;;; Wind limit - don't even try fiting VAD curve to higher wind speeds
;MAX_VEL_FOR_UNFOLD_TRIAL = 999. ;; m/s maximum possible wind at any height

;;;; du_max is a shear between levels allowed in the Doppler unfolding
;;;; process. This is a way to use reliable data from low levels to
;;;; constrain the unfolding at higher altitudes. Much room for
;;;; experimentation... du_max(0) is the max wind speed guess allowed
;;;; at the lowest altitude, then shear is constrained from there on 

SHEAR_max=fltarr(np) + 10 ;;; m/s

;;; du_max_time is the greatest change in u or v allowed from one hour
;;; to the next. Bad unfolds can proppagate... but so will good ones. 
du_max_time = 999 ;;; m/s

;;;; Override: specify a wind profile and force all winds to be near it.
;;;; If unwanted, just comment this out. 

;FORCE_UNFOLD_U = [ $
;  9.79549, 11.0318, 10.2311, 9.24763, 9.07999, 8.54162, $
;  8.11630, 8.33245, 8.70094, 8.56945, 8.22027, 7.80741, $
;  7.30639, 6.49601, 4.69345, 2.61601, .608585, 1.80508, 9.18413]
;FORCE_UNFOLD_V = [ $
;  1.69211, 2.03172, .364615, .905285, 1.48665, 2.04065, 2.84474, $
;  3.51166, 3.61873, 3.39500, 3.10852, 3.12158, 3.06021, 2.75984, $
;  2.80703, 2.56275, 3.39716, 6.58967, 2.16228]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Plotting related parameters

;;;; onepageonly just gives the final results. onepageonly=0 gives
;;;; more. 
onepageonly = 0

;;; Which radii for the divergence profiles plot
radii_to_plot = [3,5,7,9]

;;; Which p level for the horizontal cover and rainrate plot
plotalt = 2

;;; Based on the SDZ histogram, >10 dBZ SDZ is convective echo
SDZ_CONV_THRESH = 10 ;;; used only for plotting

;;; How big a circle to use for the CFAD plot 
CFAD_RANGE_BINS2 = indgen(9);; for PLOTS and another digital file output
CFAD_RANGE_BINS = indgen(4) ;; for another digital file output - wanted??

;;; WHICH Radii and P LEVELS TO PLOT VAD postage stams for

pmulti=[0,4,9,1,0] ;; [0,4,9,1,0] means 4 columns, 9 rows

plot_p =  17-indgen(18) ;;; all 18 levels on 2 pages!
;plot_p = [18,17,16,15, 9, 3, 2, 1, 0] ;; all the hard levels for unfolding
;   0-5    975.000      925.000      875.000      825.000      775.000      725.000
;   6-11   675.000      625.000      575.000      525.000      475.000      425.000
;   12-17  375.000      325.000      275.000      225.000      175.000      125.000
;   18     75.0000

plot_ra1 =3 ;; range 3 at left
plot_ra2 =9
plot_dra =2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Parameters for Z-R relationships

dbz_offset1=0 ;; calibration if known
a1=228 ;; for local ZR relation if known ...228 is GATE
b1=1.25 ;; for local ZR relation if known ...1.25 is GATE

;;; GATE Z-R relation
a0_ZR=228
b0_ZR=1.25
