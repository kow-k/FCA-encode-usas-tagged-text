#! /usr/bin/env gawk -f
## This gawk script was developed to encode texts tagged for USAS semantic tags.
## written by Kow Kuroda
## created on 2016/07/04
## modifications
## 2017/07/17: added handling of lines without object names.
## 2018/07/11: added handling of binary output using smart_printf effective if detailed=0.
## 2019/08/02: added ihandling of proper object name recognition using ::
## 2020/07/11: fixed bug in i) handling of regex matching, ii) loop counter
## 2020/07/13: added variable "objname length" to handle various obj names
## 2020/07/16:
##  revised smart_print to fix wrong operation at detailed=1 mode
##  added missed smart_print(S9)
## 2020/07/19: added gensub(..) to handle variabel objname
## 2021/07/12: modified to handle vertical mode input
## 2022/04/25: 1) revised objname-attr separator, 2) renamed "E2:Liking" to "E2:(Dis)liking"


# set up
BEGIN { debug = 0; summarized = 0; raw = 0; detailed = 0; theta = 1; include_Z = 0;
	header = "A1:Action,A2:Affect,A3:Being,A4:Classification,A5:Evaluation,A6:Comparing,A7:Definite,A8:Seem,A9:Possesion,A10:Open/Close,A11:Important,A12:Easy/Difficult,A13:Degree,A14:Exclusive/Particular,A15:Safety/Danger,B1:Physiology,B2:Health/Disease,B3:Medical,B4:Cleaning,B5:Clothes,C1:Arts/Crafts,E1:General,E2:(Dis)liking,E3:Calm/Angry,E4:Happy/Sad,E5:Fear/Bravery,E6:Worry,F1:Food,F2:Drinks,F3:Cigarettes/Drugs,F4:Farming/Horticulture,G1:Government,G2:Crime/Law,G3:Warfare,H1:Architecture,H2:Parts,H3:Areas,H4:Residence,H5:Furniture,I1:Money,I2:Business,I3:Work,I4:Industry,K1:Entertaiment,K2:Music,K3:Recording,K4:Drama/Theater,K5:Sports/Games,K6:Child_games/toys,L1:Life,L2:Creatures,L3:Plants,M1:Moving,M2:Putting/Taking,M3:Transport:land,M4:Transport:water,M5:Transport:air,M6:Location/Direction,M7:Places,M8:Remaining,N1:Numbers,N2:Mathematics,N3:Measurement,N4:Linear_order,N5:Quantities,N6:Frequencies,O1:Substances,O2:Objects,O3:Electricity,O4:Attributes,P1:Education,Q1:Communication,Q2:Speech_act,Q3:Grammar,Q4:Media,S1:Social_matter,S2:People,S3:Relationship,S4:Kin,S5:Group,S6:Obligation,S7:Power,S8:Helping/Hindering,S9:Religion/Supernatural,T1:Time,T2:Begin/End,T3:Oldness/Age,T4:Early/Late,W1:World,W2:Light,W3:Geography,W4:Weather,W5:Green_issue,X1:Psychology,X2:Mental_state/process,X3:Sensory,X4:Mental_object,X5:Attention,X6:Interest,X7:Wanting,X8:Trying,X9:Ability,Y1:Science/Technology,Y2:Information/Computing";
	header2 = "A1:Action,A2:Affect,A3:Being,A4:Classification,A5:Evaluation,A6:Comparing,A7:Definite,A8:Seem,A9:Possesion,A10:Open/Close,A11:Important,A12:Easy/Difficult,A13:Degree,A14:Exclusive/Particular,A15:Safety/Danger,B1:Physiology,B2:Health/Disease,B3:Medical,B4:Cleaning,B5:Clothes,C1:Arts/Crafts,E1:General,E2:Liking,E3:Calm/Angry,E4:Happy/Sad,E5:Fear/Bravery,E6:Worry,F1:Food,F2:Drinks,F3:Cigarettes/Drugs,F4:Farming/Horticulture,G1:Government,G2:Crime/Law,G3:Warfare,H1:Architecture,H2:Parts,H3:Areas,H4:Residence,H5:Furniture,I1:Money,I2:Business,I3:Work,I4:Industry,K1:Entertaiment,K2:Music,K3:Recording,K4:Drama/Theater,K5:Sports/Games,K6:Child_games/toys,L1:Life,L2:Creatures,L3:Plants,M1:Moving,M2:Putting/Taking,M3:Transport:land,M4:Transport:water,M5:Transport:air,M6:Location/Direction,M7:Places,M8:Remaining,N1:Numbers,N2:Mathematics,N3:Measurement,N4:Linear_order,N5:Quantities,N6:Frequencies,O1:Substances,O2:Objects,O3:Electricity,O4:Attributes,P1:Education,Q1:Communication,Q2:Speech_act,Q3:Grammar,Q4:Media,S1:Social_matter,S2:People,S3:Relationship,S4:Kin,S5:Group,S6:Obligation,S7:Power,S8:Helping/Hindering,S9:Religion/Supernatural,T1:Time,T2:Begin/End,T3:Oldness/Age,T4:Early/Late,W1:World,W2:Light,W3:Geography,W4:Weather,W5:Green_issue,X1:Psychology,X2:Mental_state/process,X3:Sensory,X4:Mental_object,X5:Attention,X6:Interest,X7:Wanting,X8:Trying,X9:Ability,Y1:Science/Technology,Y2:Information/Computing,Z1:Unmatched_proper_noun,Z2:Personal_name,Z3:Other_proper_name,Z4:Discourse_bin,Z5:Grammatical_bin,Z6:Negative,Z7:If,Z8:Pronoun,Z9:Trashcan,Z99:Unmatched";
}

## main
{	# print attributes
	if (NR == 1) {
		if (include_Z) { print header2 } else { print header }
	}
	# Output is done recordwise.
	record = $0
	if (debug) { print "\n#processing:", record }
	# get obj name
	if ($1 ~ /^[A-Za-z0-9.+]+.*/ ) {
		#obj = gensub(/^([A-Za-z0-9.+]+).*/, "\\1", "g")
		obj = gensub(/^(.+)\W*::\W*.+/, "\\1", "g") # "::" serves as objname-attr separator
		}
	else
		if (length(obj) == 0) { obj = "Obj" NR } # obj = "Obj" NR
	printf obj # This needs to come here
	# refresh the records
	initialize()
	get_encoding(record)
	# generate output
	show_encoding(obj)
}

# finalization
END { }

# function definitions

function initialize() {
	# initialization
	obj="";
	A1=0; A2=0; A3=0; A4=0; A5=0; A6=0; A7=0; A8=0; A9=0; A10=0;
	A11=0; A12=0; A13=0; A14=0; A15=0;
	B1=0; B2=0; B3=0; B4=0; B5=0;
	C1=0;
	E1=0; E2=0; E3=0; E4=0; E5=0; E6=0;
	F1=0; F2=0; F3=0; F4=0;
	G1=0; G2=0; G3=0;
	H1=0; H2=0; H3=0; H4=0; H5=0;
	I1=0; I2=0; I3=0; I4=0;
	K1=0; K2=0; K3=0; K4=0; K5=0; K6=0;
	L1=0; L2=0; L3=0;
	M1=0; M2=0; M3=0; M4=0; M5=0; M6=0; M7=0; M8=0;
	N1=0; N2=0; N3=0; N4=0; N5=0; N6=0;
	O1=0; O2=0; O3=0; O4=0;
	P1=0;
	Q1=0; Q2=0; Q3=0; Q4=0;
	S1=0; S2=0; S3=0; S4=0; S5=0; S6=0; S7=0; S8=0; S9=0;
	T1=0; T2=0; T3=0; T4=0;
	W1=0; W2=0; W3=0; W4=0; W5=0;
	X1=0; X2=0; X3=0; X4=0; X5=0; X6=0; X7=0; X8=0; X9=0;
	Y1=0; Y2=0;
	Z1=0; Z2=0; Z3=0; Z4=0; Z5=0; Z6=0; Z7=0; Z8=0; Z9=0; Z99=0;
}

function get_encoding(x) {
	# A
	if (x ~ /.+A1[^0-9]*/) { A1++; A1L[A1] = x }
	if (x ~ /.+A2[^0-9]*/) { A2++; A2L[A2] = x }
	if (x ~ /.+A3[^0-9]*/) { A3++; A3L[A3] = x }
	if (x ~ /.+A4[^0-9]*/) { A4++; A4L[A4] = x }
	if (x ~ /.+A5[^0-9]*/) { A5++; A5L[A5] = x }
	if (x ~ /.+A6[^0-9]*/) { A6++; A6L[A6] = x }
	if (x ~ /.+A7[^0-9]*/) { A7++; A7L[A7] = x }
	if (x ~ /.+A8[^0-9]*/) { A8++; A8L[A8] = x }
	if (x ~ /.+A9[^0-9]*/) { A9++; A9L[A9] = x }
	if (x ~ /.+A10[^0-9]*/) { A10++; A10L[A10] = x }
	if (x ~ /.+A11[^0-9]*/) { A11++; A11L[A11] = x }
	if (x ~ /.+A12[^0-9]*/) { A12++; A12L[A12] = x }
	if (x ~ /.+A13[^0-9]*/) { A13++; A13L[A13] = x }
	if (x ~ /.+A14[^0-9]*/) { A14++; A14L[A14] = x }
	if (x ~ /.+A15[^0-9]*/) { A15++; A15L[A15] = x }
	# B
	if (x ~ /.+B1[^0-9]*/) { B1++; B1L[B1] = x }
	if (x ~ /.+B2[^0-9]*/) { B2++; B2L[B2] = x }
	if (x ~ /.+B3[^0-9]*/) { B3++; B3L[B3] = x }
	if (x ~ /.+B4[^0-9]*/) { B4++; B4L[B4] = x }
	if (x ~ /.+B5[^0-9]*/) { B5++; B5L[B5] = x }
	# C
	if (x ~ /.+C1[^0-9]*/) { C1++; C1L[C1] = x }
	# E
	if (x ~ /.+E1[^0-9]*/) { E1++; E1L[E1] = x }
	if (x ~ /.+E2[^0-9]*/) { E2++; E2L[E2] = x }
	if (x ~ /.+E3[^0-9]*/) { E3++; E3L[E3] = x }
	if (x ~ /.+E4[^0-9]*/) { E4++; E4L[E4] = x }
	if (x ~ /.+E5[^0-9]*/) { E5++; E5L[E5] = x }
	if (x ~ /.+E6[^0-9]*/) { E6++; E6L[E6] = x }
	# F
	if (x ~ /.+F1[^0-9]*/) { F1++; F1L[F1] = x }
	if (x ~ /.+F2[^0-9]*/) { F2++; F2L[F2] = x }
	if (x ~ /.+F3[^0-9]*/) { F3++; F3L[F3] = x }
	if (x ~ /.+F4[^0-9]*/) { F4++; F4L[F4] = x }
	# G
	if (x ~ /.+G1[^0-9]*/) { G1++; G1L[G1] = x }
	if (x ~ /.+G2[^0-9]*/) { G2++; G2L[G2] = x }
	if (x ~ /.+G3[^0-9]*/) { G3++; G3L[G3] = x }
	# H
	if (x ~ /.+H1[^0-9]*/) { H1++; H1L[H1] = x }
	if (x ~ /.+H2[^0-9]*/) { H2++; H2L[H2] = x }
	if (x ~ /.+H3[^0-9]*/) { H3++; H3L[H3] = x }
	if (x ~ /.+H4[^0-9]*/) { H4++; H4L[H4] = x }
	if (x ~ /.+H5[^0-9]*/) { H5++; H5L[H5] = x }
	# I
	if (x ~ /.+I1[^0-9]*/) { I1++; I1L[I1] = x }
	if (x ~ /.+I2[^0-9]*/) { I2++; I2L[I2] = x }
	if (x ~ /.+I3[^0-9]*/) { I3++; I3L[I3] = x }
	if (x ~ /.+I4[^0-9]*/) { I4++; I4L[I4] = x }
	# K
	if (x ~ /.+K1[^0-9]*/) { K1++; K1L[K1] = x }
	if (x ~ /.+K2[^0-9]*/) { K2++; K2L[K2] = x }
	if (x ~ /.+K3[^0-9]*/) { K3++; K3L[K3] = x }
	if (x ~ /.+K4[^0-9]*/) { K4++; K4L[K4] = x }
	if (x ~ /.+K5[^0-9]*/) { K5++; K5L[K5] = x }
	if (x ~ /.+K6[^0-9]*/) { K6++; K6L[K6] = x }
	# L
	if (x ~ /.+L1[^0-9]*/) { L1++; L1L[L1] = x }
	if (x ~ /.+L2[^0-9]*/) { L2++; L2L[L2] = x }
	if (x ~ /.+L3[^0-9]*/) { L3++; L3L[L3] = x }
	# M
	if (x ~ /.+M1[^0-9]*/) { M1++; M1L[M1] = x }
	if (x ~ /.+M2[^0-9]*/) { M2++; M2L[M2] = x }
	if (x ~ /.+M3[^0-9]*/) { M3++; M3L[M3] = x }
	if (x ~ /.+M4[^0-9]*/) { M4++; M4L[M4] = x }
	if (x ~ /.+M5[^0-9]*/) { M5++; M5L[M5] = x }
	if (x ~ /.+M6[^0-9]*/) { M6++; M6L[M6] = x }
	if (x ~ /.+M7[^0-9]*/) { M7++; M7L[M7] = x }
	if (x ~ /.+M8[^0-9]*/) { M8++; M8L[M8] = x }
	# N
	if (x ~ /.+N1[^0-9]*/) { N1++; N1L[N1] = x }
	if (x ~ /.+N2[^0-9]*/) { N2++; N2L[N2] = x }
	if (x ~ /.+N3[^0-9]*/) { N3++; N3L[N3] = x }
	if (x ~ /.+N4[^0-9]*/) { N4++; N4L[N4] = x }
	if (x ~ /.+N5[^0-9]*/) { N5++; N5L[N5] = x }
	if (x ~ /.+N6[^0-9]*/) { N6++; N6L[N6] = x }
	# O
	if (x ~ /.+O1[^0-9]*/) { O1++; O1L[O1] = x }
	if (x ~ /.+O2[^0-9]*/) { O2++; O2L[O2] = x }
	if (x ~ /.+O3[^0-9]*/) { O3++; O3L[O3] = x }
	if (x ~ /.+O4[^0-9]*/) { O4++; O4L[O4] = x }
	# P
	if (x ~ /.+P1[^0-9]*/) { P1++; P1L[P1] = x }
	# Q
	if (x ~ /.+Q1[^0-9]*/) { Q1++; Q1L[Q1] = x }
	if (x ~ /.+Q2[^0-9]*/) { Q2++; Q2L[Q2] = x }
	if (x ~ /.+Q3[^0-9]*/) { Q3++; Q3L[Q3] = x }
	if (x ~ /.+Q4[^0-9]*/) { Q4++; Q4L[Q4] = x }
	# S
	if (x ~ /.+S1[^0-9]*/) { S1++; S1L[S1] = x }
	if (x ~ /.+S2[^0-9]*/) { S2++; S2L[S2] = x }
	if (x ~ /.+S3[^0-9]*/) { S3++; S3L[S3] = x }
	if (x ~ /.+S4[^0-9]*/) { S4++; S4L[S4] = x }
	if (x ~ /.+S5[^0-9]*/) { S5++; S5L[S5] = x }
	if (x ~ /.+S6[^0-9]*/) { S6++; S6L[S6] = x }
	if (x ~ /.+S7[^0-9]*/) { S7++; S7L[S7] = x }
	if (x ~ /.+S8[^0-9]*/) { S8++; S8L[S8] = x }
	if (x ~ /.+S9[^0-9]*/) { S9++; S9L[S9] = x }
	# T
	if (x ~ /.+T1[^0-9]*/) { T1++; T1L[T1] = x }
	if (x ~ /.+T2[^0-9]*/) { T2++; T2L[T2] = x }
	if (x ~ /.+T3[^0-9]*/) { T3++; T3L[T3] = x }
	if (x ~ /.+T4[^0-9]*/) { T4++; T4L[T4] = x }
	# W
	if (x ~ /.+W1[^0-9]*/) { W1++; W1L[W1] = x }
	if (x ~ /.+W2[^0-9]*/) { W2++; W2L[W2] = x }
	if (x ~ /.+W3[^0-9]*/) { W3++; W3L[W3] = x }
	if (x ~ /.+W4[^0-9]*/) { W4++; W4L[W4] = x }
	if (x ~ /.+W5[^0-9]*/) { W5++; W5L[W5] = x }
	# X
	if (x ~ /.+X1[^0-9]*/) { X1++; X1L[X1] = x }
	if (x ~ /.+X2[^0-9]*/) { X2++; X2L[X2] = x }
	if (x ~ /.+X3[^0-9]*/) { X3++; X3L[X3] = x }
	if (x ~ /.+X4[^0-9]*/) { X4++; X4L[X4] = x }
	if (x ~ /.+X5[^0-9]*/) { X5++; X5L[X5] = x }
	if (x ~ /.+X6[^0-9]*/) { X6++; X6L[X6] = x }
	if (x ~ /.+X7[^0-9]*/) { X7++; X7L[X7] = x }
	if (x ~ /.+X8[^0-9]*/) { X8++; X8L[X8] = x }
	if (x ~ /.+X9[^0-9]*/) { X9++; X9L[X9] = x }
	# Y
	if (x ~ /.+Y1[^0-9]*/) { Y1++; Y1L[Y1] = x }
	if (x ~ /.+Y2[^0-9]*/) { Y2++; Y2L[Y2] = x }
	# Z
	if (x ~ /.+Z1[^0-9]*/)  { Z1++ ; Z1L[Z1] = x }
	if (x ~ /.+Z2[^0-9]*/)  { Z2++ ; Z2L[Z2] = x }
	if (x ~ /.+Z3[^0-9]*/)  { Z3++ ; Z3L[Z3] = x }
	if (x ~ /.+Z4[^0-9]*/)  { Z4++ ; Z4L[Z4] = x }
	if (x ~ /.+Z5[^0-9]*/)  { Z5++ ; Z5L[Z5] = x }
	if (x ~ /.+Z6[^0-9]*/)  { Z6++ ; Z6L[Z6] = x }
	if (x ~ /.+Z7[^0-9]*/)  { Z7++ ; Z7L[Z7] = x }
	if (x ~ /.+Z8[^0-9]*/)  { Z8++ ; Z8L[Z8] = x }
	if (x ~ /.+Z9[^0-9]*/)  { Z9++ ; Z9L[Z9] = x }
	if (x ~ /.+Z99[^0-9]*/) { Z99++ ; Z99L[Z99] = x }
}

function show_encoding(x) {
	#printf x ","
	printf x
	# A
	smart_printf(A1) ;
	smart_printf(A2) ;
	smart_printf(A3) ;
	smart_printf(A4) ;
	smart_printf(A5) ;
	smart_printf(A6) ;
	smart_printf(A7) ;
	smart_printf(A8) ;
	smart_printf(A9) ;
	smart_printf(A10) ;
	smart_printf(A11) ;
	smart_printf(A12) ;
	smart_printf(A13) ;
	smart_printf(A14) ;
	smart_printf(A15) ;
	# B
	smart_printf(B1) ;
	smart_printf(B2) ;
	smart_printf(B3) ;
	smart_printf(B4) ;
	smart_printf(B5) ;
	# C
	smart_printf(C1) ;
	# E
	smart_printf(E1) ;
	smart_printf(E2) ;
	smart_printf(E3) ;
	smart_printf(E4) ;
	smart_printf(E5) ;
	smart_printf(E6) ;
	# F
	smart_printf(F1) ;
	smart_printf(F2) ;
	smart_printf(F3) ;
	smart_printf(F4) ;
	# G
	smart_printf(G1) ;
	smart_printf(G2) ;
	smart_printf(G3) ;
	# H
	smart_printf(H1) ;
	smart_printf(H2) ;
	smart_printf(H3) ;
	smart_printf(H4) ;
	smart_printf(H5) ;
	# I
	smart_printf(I1) ;
	smart_printf(I2) ;
	smart_printf(I3) ;
	smart_printf(I4) ;
	# K
	smart_printf(K1) ;
	smart_printf(K2) ;
	smart_printf(K3) ;
	smart_printf(K4) ;
	smart_printf(K5) ;
	smart_printf(K6) ;
	# L
	smart_printf(L1) ;
	smart_printf(L2) ;
	smart_printf(L3) ;
	# M
	smart_printf(M1) ;
	smart_printf(M2) ;
	smart_printf(M3) ;
	smart_printf(M4) ;
	smart_printf(M5) ;
	smart_printf(M6) ;
	smart_printf(M7) ;
	smart_printf(M8) ;
	# N
	smart_printf(N1) ;
	smart_printf(N2) ;
	smart_printf(N3) ;
	smart_printf(N4) ;
	smart_printf(N5) ;
	smart_printf(N6) ;
	# O
	smart_printf(O1) ;
	smart_printf(O2) ;
	smart_printf(O3) ;
	smart_printf(O4) ;
	# P
	smart_printf(P1) ;
	# Q
	smart_printf(Q1) ;
	smart_printf(Q2) ;
	smart_printf(Q3) ;
	smart_printf(Q4) ;
	# S
	smart_printf(S1) ;
	smart_printf(S2) ;
	smart_printf(S3) ;
	smart_printf(S4) ;
	smart_printf(S5) ;
	smart_printf(S6) ;
	smart_printf(S7) ;
	smart_printf(S8) ;
	smart_printf(S9) ; # added on 2020/07/16
	# T
	smart_printf(T1) ;
	smart_printf(T2) ;
	smart_printf(T3) ;
	smart_printf(T4) ;
	# W
	smart_printf(W1) ;
	smart_printf(W2) ;
	smart_printf(W3) ;
	smart_printf(W4) ;
	smart_printf(W5) ;
	# X
	smart_printf(X1) ;
	smart_printf(X2) ;
	smart_printf(X3) ;
	smart_printf(X4) ;
	smart_printf(X5) ;
	smart_printf(X6) ;
	smart_printf(X7) ;
	smart_printf(X8) ;
	smart_printf(X9) ;
	# Y
	smart_printf(Y1) ;
	smart_printf(Y2) ;
	# Z
	if (include_Z)
	{ # print Z
		smart_printf(Z1) ;
		smart_printf(Z2) ;
		smart_printf(Z3) ;
		smart_printf(Z4) ;
		smart_printf(Z5) ;
		smart_printf(Z6) ;
		smart_printf(Z7) ;
		smart_printf(Z8) ;
		smart_printf(Z9) ;
		smart_printf(Z99) ;
	}
	printf "\n"
}

function smart_printf(arg) {
	if (debug) { print "\n#processing: " arg }
	if (raw) {
		printf "," arg
	} else {
		if (arg > (theta - 1)) {
			printf ",1"
		} else {
			printf ",0"
		}
	}
}

# end of program
