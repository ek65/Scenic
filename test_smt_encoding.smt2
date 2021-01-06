(set-logic QF_NRA)
VectorOperatorDistribution
self.object: PointIn(Options(<LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>, <LaneSection>))
PointInRegionDistribution
Options class
creating a variable x1
(declare-fun x1 () Real)
creating a variable y1
(declare-fun y1 () Real)
# of network elements: 1
Options elem: <class 'scenic.domains.driving.roads.LaneSection'>
roads.py Class LaneSection encodeToSMT
Class PolygonalRegion
encodePolygonalRegion_SMT
creating a variable s1
(declare-fun s1 () Real)
creating a variable t1
(declare-fun t1 () Real)
creating a variable x2
(declare-fun x2 () Real)
creating a variable y2
(declare-fun y2 () Real)
(assert (and (<= 0 s1) (<= s1 1)))
(assert (and (<= 0 t1) (<= t1 1)))
(assert (<= (+ s1 t1) 1))
p0: (31.91755930995568, 102.20851933190025)
p1: (31.977449395565632, 104.44771855877704)
p2: (28.47870060357064, 104.54129681754257)
p0: (28.47870060357064, 104.54129681754257)
p1: (28.41881051796069, 102.30209759066577)
p2: (31.91755930995568, 102.20851933190025)
(assert (or (and (= x2 (+ 31.91755930995568 (+ (* (- 31.977449395565632 31.91755930995568) s1) (* (- 28.47870060357064 31.91755930995568) t1)))) (= y2 (+ 102.20851933190025 (+ (* (- 104.44771855877704 102.20851933190025) s1) (* (- 104.54129681754257 102.20851933190025) t1))))) (and (= x2 (+ 28.47870060357064 (+ (* (- 28.41881051796069 28.47870060357064) s1) (* (- 31.91755930995568 28.47870060357064) t1)))) (= y2 (+ 104.54129681754257 (+ (* (- 102.30209759066577 104.54129681754257) s1) (* (- 102.20851933190025 104.54129681754257) t1)))))))
(assert (= x2 x1))
(assert (= y2 y1))
offsetRotated
offsetRotatedEncodeToSMT()
rotatedByEncodeToSMT()
(declare-fun x3 () Real)
(declare-fun y3 () Real)
(assert (= x2 x3))
(assert (= y2 y3))
