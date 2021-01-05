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
p0: (101.68068088098245, 13.208595871858138)
p1: (101.67787396817701, 12.258600018582724)
p2: (105.17785869077068, 12.248258760878839)
p0: (105.17785869077068, 12.248258760878839)
p1: (105.18066560357612, 13.198254614154253)
p2: (101.68068088098245, 13.208595871858138)
(assert (or (and (= x2 (+ 101.68068088098245 (+ (* (- 101.67787396817701 101.68068088098245) s1) (* (- 105.17785869077068 101.68068088098245) t1)))) (= y2 (+ 13.208595871858138 (+ (* (- 12.258600018582724 13.208595871858138) s1) (* (- 12.248258760878839 13.208595871858138) t1))))) (and (= x2 (+ 105.17785869077068 (+ (* (- 105.18066560357612 105.17785869077068) s1) (* (- 101.68068088098245 105.17785869077068) t1)))) (= y2 (+ 12.248258760878839 (+ (* (- 13.198254614154253 12.248258760878839) s1) (* (- 13.208595871858138 12.248258760878839) t1)))))))
(assert (= x2 x1))
(assert (= y2 y1))
offsetRotated
offsetRotatedEncodeToSMT()
rotatedByEncodeToSMT()
(declare-fun x3 () Real)
(declare-fun y3 () Real)
(assert (= x2 x3))
(assert (= y2 y3))
