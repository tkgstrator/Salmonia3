//
//  SplatInk.swift
//  Salmonia3
//
//  Created by devonly on 2022/03/25.
//  
//

import SwiftUI

struct SplatInk: Shape {
    func path(in rect: CGRect) -> Path {
        //// Bezier Drawing
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + 0.73047 * rect.width, y: rect.minY + 0.40373 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.83208 * rect.width, y: rect.minY + 0.27199 * rect.height), control1: CGPoint(x: rect.minX + 0.73349 * rect.width, y: rect.minY + 0.33311 * rect.height), control2: CGPoint(x: rect.minX + 0.82591 * rect.width, y: rect.minY + 0.35640 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.76329 * rect.width, y: rect.minY + 0.21907 * rect.height), control1: CGPoint(x: rect.minX + 0.83436 * rect.width, y: rect.minY + 0.24050 * rect.height), control2: CGPoint(x: rect.minX + 0.79678 * rect.width, y: rect.minY + 0.21298 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.68275 * rect.width, y: rect.minY + 0.29472 * rect.height), control1: CGPoint(x: rect.minX + 0.72463 * rect.width, y: rect.minY + 0.22609 * rect.height), control2: CGPoint(x: rect.minX + 0.69671 * rect.width, y: rect.minY + 0.26068 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.57792 * rect.width, y: rect.minY + 0.32658 * rect.height), control1: CGPoint(x: rect.minX + 0.66933 * rect.width, y: rect.minY + 0.32714 * rect.height), control2: CGPoint(x: rect.minX + 0.61309 * rect.width, y: rect.minY + 0.34329 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.53611 * rect.width, y: rect.minY + 0.23410 * rect.height), control1: CGPoint(x: rect.minX + 0.53215 * rect.width, y: rect.minY + 0.30478 * rect.height), control2: CGPoint(x: rect.minX + 0.52758 * rect.width, y: rect.minY + 0.26031 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.55342 * rect.width, y: rect.minY + 0.04776 * rect.height), control1: CGPoint(x: rect.minX + 0.54564 * rect.width, y: rect.minY + 0.20460 * rect.height), control2: CGPoint(x: rect.minX + 0.57094 * rect.width, y: rect.minY + 0.11348 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.47738 * rect.width, y: rect.minY + 0.00112 * rect.height), control1: CGPoint(x: rect.minX + 0.54544 * rect.width, y: rect.minY + 0.01789 * rect.height), control2: CGPoint(x: rect.minX + 0.51007 * rect.width, y: rect.minY + -0.00540 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.42369 * rect.width, y: rect.minY + 0.08988 * rect.height), control1: CGPoint(x: rect.minX + 0.43839 * rect.width, y: rect.minY + 0.00888 * rect.height), control2: CGPoint(x: rect.minX + 0.42174 * rect.width, y: rect.minY + 0.05304 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.43919 * rect.width, y: rect.minY + 0.28658 * rect.height), control1: CGPoint(x: rect.minX + 0.42564 * rect.width, y: rect.minY + 0.12671 * rect.height), control2: CGPoint(x: rect.minX + 0.46336 * rect.width, y: rect.minY + 0.21031 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.40517 * rect.width, y: rect.minY + 0.31950 * rect.height), control1: CGPoint(x: rect.minX + 0.43631 * rect.width, y: rect.minY + 0.29565 * rect.height), control2: CGPoint(x: rect.minX + 0.42376 * rect.width, y: rect.minY + 0.31615 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.24718 * rect.width, y: rect.minY + 0.41944 * rect.height), control1: CGPoint(x: rect.minX + 0.33953 * rect.width, y: rect.minY + 0.33137 * rect.height), control2: CGPoint(x: rect.minX + 0.30342 * rect.width, y: rect.minY + 0.33509 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.14597 * rect.width, y: rect.minY + 0.39037 * rect.height), control1: CGPoint(x: rect.minX + 0.23309 * rect.width, y: rect.minY + 0.44056 * rect.height), control2: CGPoint(x: rect.minX + 0.18101 * rect.width, y: rect.minY + 0.42360 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.04027 * rect.width, y: rect.minY + 0.38584 * rect.height), control1: CGPoint(x: rect.minX + 0.12302 * rect.width, y: rect.minY + 0.36820 * rect.height), control2: CGPoint(x: rect.minX + 0.07859 * rect.width, y: rect.minY + 0.36224 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.04031 * rect.width, y: rect.minY + 0.38582 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.01531 * rect.width, y: rect.minY + 0.46149 * rect.height), control1: CGPoint(x: rect.minX + 0.01324 * rect.width, y: rect.minY + 0.40208 * rect.height), control2: CGPoint(x: rect.minX + 0.00270 * rect.width, y: rect.minY + 0.43399 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.11094 * rect.width, y: rect.minY + 0.50578 * rect.height), control1: CGPoint(x: rect.minX + 0.02671 * rect.width, y: rect.minY + 0.48994 * rect.height), control2: CGPoint(x: rect.minX + 0.06886 * rect.width, y: rect.minY + 0.50832 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.20134 * rect.width, y: rect.minY + 0.58137 * rect.height), control1: CGPoint(x: rect.minX + 0.17309 * rect.width, y: rect.minY + 0.50205 * rect.height), control2: CGPoint(x: rect.minX + 0.20134 * rect.width, y: rect.minY + 0.54037 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.12000 * rect.width, y: rect.minY + 0.65770 * rect.height), control1: CGPoint(x: rect.minX + 0.20134 * rect.width, y: rect.minY + 0.62783 * rect.height), control2: CGPoint(x: rect.minX + 0.16839 * rect.width, y: rect.minY + 0.65758 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.02872 * rect.width, y: rect.minY + 0.67012 * rect.height), control1: CGPoint(x: rect.minX + 0.09409 * rect.width, y: rect.minY + 0.65770 * rect.height), control2: CGPoint(x: rect.minX + 0.05779 * rect.width, y: rect.minY + 0.65373 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.02899 * rect.width, y: rect.minY + 0.66998 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.00258 * rect.width, y: rect.minY + 0.73047 * rect.height), control1: CGPoint(x: rect.minX + 0.00622 * rect.width, y: rect.minY + 0.68215 * rect.height), control2: CGPoint(x: rect.minX + -0.00467 * rect.width, y: rect.minY + 0.70709 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.09081 * rect.width, y: rect.minY + 0.75919 * rect.height), control1: CGPoint(x: rect.minX + 0.01510 * rect.width, y: rect.minY + 0.76398 * rect.height), control2: CGPoint(x: rect.minX + 0.04966 * rect.width, y: rect.minY + 0.77776 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.21409 * rect.width, y: rect.minY + 0.71398 * rect.height), control1: CGPoint(x: rect.minX + 0.12691 * rect.width, y: rect.minY + 0.74292 * rect.height), control2: CGPoint(x: rect.minX + 0.18141 * rect.width, y: rect.minY + 0.70857 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.25859 * rect.width, y: rect.minY + 0.76932 * rect.height), control1: CGPoint(x: rect.minX + 0.24463 * rect.width, y: rect.minY + 0.71901 * rect.height), control2: CGPoint(x: rect.minX + 0.25953 * rect.width, y: rect.minY + 0.74304 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.32228 * rect.width, y: rect.minY + 0.80037 * rect.height), control1: CGPoint(x: rect.minX + 0.25779 * rect.width, y: rect.minY + 0.79168 * rect.height), control2: CGPoint(x: rect.minX + 0.27611 * rect.width, y: rect.minY + 0.81416 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.38201 * rect.width, y: rect.minY + 0.84385 * rect.height), control1: CGPoint(x: rect.minX + 0.35403 * rect.width, y: rect.minY + 0.79112 * rect.height), control2: CGPoint(x: rect.minX + 0.37765 * rect.width, y: rect.minY + 0.81901 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.35691 * rect.width, y: rect.minY + 0.91130 * rect.height), control1: CGPoint(x: rect.minX + 0.38691 * rect.width, y: rect.minY + 0.87224 * rect.height), control2: CGPoint(x: rect.minX + 0.37732 * rect.width, y: rect.minY + 0.88180 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.36933 * rect.width, y: rect.minY + 0.98509 * rect.height), control1: CGPoint(x: rect.minX + 0.33302 * rect.width, y: rect.minY + 0.94590 * rect.height), control2: CGPoint(x: rect.minX + 0.34658 * rect.width, y: rect.minY + 0.97677 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.36978 * rect.width, y: rect.minY + 0.98527 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.44428 * rect.width, y: rect.minY + 0.97124 * rect.height), control1: CGPoint(x: rect.minX + 0.39536 * rect.width, y: rect.minY + 0.99532 * rect.height), control2: CGPoint(x: rect.minX + 0.42498 * rect.width, y: rect.minY + 0.98974 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.45859 * rect.width, y: rect.minY + 0.89335 * rect.height), control1: CGPoint(x: rect.minX + 0.46248 * rect.width, y: rect.minY + 0.95348 * rect.height), control2: CGPoint(x: rect.minX + 0.45919 * rect.width, y: rect.minY + 0.92727 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.48812 * rect.width, y: rect.minY + 0.83124 * rect.height), control1: CGPoint(x: rect.minX + 0.45812 * rect.width, y: rect.minY + 0.86851 * rect.height), control2: CGPoint(x: rect.minX + 0.46685 * rect.width, y: rect.minY + 0.84652 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.57275 * rect.width, y: rect.minY + 0.81261 * rect.height), control1: CGPoint(x: rect.minX + 0.50443 * rect.width, y: rect.minY + 0.81944 * rect.height), control2: CGPoint(x: rect.minX + 0.53792 * rect.width, y: rect.minY + 0.80957 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.62154 * rect.width, y: rect.minY + 0.85758 * rect.height), control1: CGPoint(x: rect.minX + 0.60631 * rect.width, y: rect.minY + 0.81559 * rect.height), control2: CGPoint(x: rect.minX + 0.61826 * rect.width, y: rect.minY + 0.84590 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.68866 * rect.width, y: rect.minY + 0.82118 * rect.height), control1: CGPoint(x: rect.minX + 0.63987 * rect.width, y: rect.minY + 0.92217 * rect.height), control2: CGPoint(x: rect.minX + 0.75114 * rect.width, y: rect.minY + 0.87901 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.67396 * rect.width, y: rect.minY + 0.74870 * rect.height), control1: CGPoint(x: rect.minX + 0.66550 * rect.width, y: rect.minY + 0.79963 * rect.height), control2: CGPoint(x: rect.minX + 0.65423 * rect.width, y: rect.minY + 0.77255 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.75698 * rect.width, y: rect.minY + 0.70137 * rect.height), control1: CGPoint(x: rect.minX + 0.69221 * rect.width, y: rect.minY + 0.72665 * rect.height), control2: CGPoint(x: rect.minX + 0.72570 * rect.width, y: rect.minY + 0.70360 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.89631 * rect.width, y: rect.minY + 0.77211 * rect.height), control1: CGPoint(x: rect.minX + 0.79866 * rect.width, y: rect.minY + 0.69839 * rect.height), control2: CGPoint(x: rect.minX + 0.84738 * rect.width, y: rect.minY + 0.75522 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.99275 * rect.width, y: rect.minY + 0.75671 * rect.height), control1: CGPoint(x: rect.minX + 0.93020 * rect.width, y: rect.minY + 0.78385 * rect.height), control2: CGPoint(x: rect.minX + 0.97362 * rect.width, y: rect.minY + 0.78522 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.96208 * rect.width, y: rect.minY + 0.67075 * rect.height), control1: CGPoint(x: rect.minX + 1.01423 * rect.width, y: rect.minY + 0.72466 * rect.height), control2: CGPoint(x: rect.minX + 0.99013 * rect.width, y: rect.minY + 0.68435 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.78799 * rect.width, y: rect.minY + 0.62491 * rect.height), control1: CGPoint(x: rect.minX + 0.90711 * rect.width, y: rect.minY + 0.64416 * rect.height), control2: CGPoint(x: rect.minX + 0.81886 * rect.width, y: rect.minY + 0.64944 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.79141 * rect.width, y: rect.minY + 0.48981 * rect.height), control1: CGPoint(x: rect.minX + 0.76651 * rect.width, y: rect.minY + 0.60783 * rect.height), control2: CGPoint(x: rect.minX + 0.81255 * rect.width, y: rect.minY + 0.53969 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.73047 * rect.width, y: rect.minY + 0.40373 * rect.height), control1: CGPoint(x: rect.minX + 0.77309 * rect.width, y: rect.minY + 0.44621 * rect.height), control2: CGPoint(x: rect.minX + 0.72879 * rect.width, y: rect.minY + 0.44385 * rect.height))
        path.closeSubpath()

        path.move(to: CGPoint(x: rect.minX + 0.12718 * rect.width, y: rect.minY + 0.87578 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.17336 * rect.width, y: rect.minY + 0.81509 * rect.height), control1: CGPoint(x: rect.minX + 0.11034 * rect.width, y: rect.minY + 0.85124 * rect.height), control2: CGPoint(x: rect.minX + 0.13799 * rect.width, y: rect.minY + 0.80913 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.20799 * rect.width, y: rect.minY + 0.87963 * rect.height), control1: CGPoint(x: rect.minX + 0.20275 * rect.width, y: rect.minY + 0.82006 * rect.height), control2: CGPoint(x: rect.minX + 0.22671 * rect.width, y: rect.minY + 0.85621 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.20792 * rect.width, y: rect.minY + 0.87972 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.14061 * rect.width, y: rect.minY + 0.88958 * rect.height), control1: CGPoint(x: rect.minX + 0.19227 * rect.width, y: rect.minY + 0.89964 * rect.height), control2: CGPoint(x: rect.minX + 0.16214 * rect.width, y: rect.minY + 0.90406 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.12720 * rect.width, y: rect.minY + 0.87580 * rect.height), control1: CGPoint(x: rect.minX + 0.13514 * rect.width, y: rect.minY + 0.88591 * rect.height), control2: CGPoint(x: rect.minX + 0.13057 * rect.width, y: rect.minY + 0.88122 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.12718 * rect.width, y: rect.minY + 0.87578 * rect.height))
        path.closeSubpath()

        
        path.move(to: CGPoint(x: rect.minX + 0.18349 * rect.width, y: rect.minY + 0.25571 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.21631 * rect.width, y: rect.minY + 0.32056 * rect.height), control1: CGPoint(x: rect.minX + 0.21765 * rect.width, y: rect.minY + 0.25522 * rect.height), control2: CGPoint(x: rect.minX + 0.23275 * rect.width, y: rect.minY + 0.29478 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.13758 * rect.width, y: rect.minY + 0.30907 * rect.height), control1: CGPoint(x: rect.minX + 0.19987 * rect.width, y: rect.minY + 0.34634 * rect.height), control2: CGPoint(x: rect.minX + 0.14523 * rect.width, y: rect.minY + 0.34348 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.13758 * rect.width, y: rect.minY + 0.30905 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.17433 * rect.width, y: rect.minY + 0.25667 * rect.height), control1: CGPoint(x: rect.minX + 0.13210 * rect.width, y: rect.minY + 0.28520 * rect.height), control2: CGPoint(x: rect.minX + 0.14856 * rect.width, y: rect.minY + 0.26174 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.18342 * rect.width, y: rect.minY + 0.25572 * rect.height), control1: CGPoint(x: rect.minX + 0.17732 * rect.width, y: rect.minY + 0.25609 * rect.height), control2: CGPoint(x: rect.minX + 0.18037 * rect.width, y: rect.minY + 0.25576 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.18349 * rect.width, y: rect.minY + 0.25571 * rect.height))
        path.closeSubpath()

        path.move(to: CGPoint(x: rect.minX + 0.03436 * rect.width, y: rect.minY + 0.26130 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.07034 * rect.width, y: rect.minY + 0.23565 * rect.height), control1: CGPoint(x: rect.minX + 0.02993 * rect.width, y: rect.minY + 0.24267 * rect.height), control2: CGPoint(x: rect.minX + 0.05248 * rect.width, y: rect.minY + 0.22981 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.07282 * rect.width, y: rect.minY + 0.27994 * rect.height), control1: CGPoint(x: rect.minX + 0.08819 * rect.width, y: rect.minY + 0.24149 * rect.height), control2: CGPoint(x: rect.minX + 0.09309 * rect.width, y: rect.minY + 0.27161 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.07265 * rect.width, y: rect.minY + 0.28001 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.03604 * rect.width, y: rect.minY + 0.26632 * rect.height), control1: CGPoint(x: rect.minX + 0.05845 * rect.width, y: rect.minY + 0.28558 * rect.height), control2: CGPoint(x: rect.minX + 0.04206 * rect.width, y: rect.minY + 0.27945 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.03433 * rect.width, y: rect.minY + 0.26115 * rect.height), control1: CGPoint(x: rect.minX + 0.03527 * rect.width, y: rect.minY + 0.26466 * rect.height), control2: CGPoint(x: rect.minX + 0.03470 * rect.width, y: rect.minY + 0.26292 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.03436 * rect.width, y: rect.minY + 0.26130 * rect.height))
        path.closeSubpath()

        path.move(to: CGPoint(x: rect.minX + 0.63685 * rect.width, y: rect.minY + 0.97863 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.67282 * rect.width, y: rect.minY + 0.95298 * rect.height), control1: CGPoint(x: rect.minX + 0.63242 * rect.width, y: rect.minY + 0.96000 * rect.height), control2: CGPoint(x: rect.minX + 0.65497 * rect.width, y: rect.minY + 0.94714 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.67530 * rect.width, y: rect.minY + 0.99727 * rect.height), control1: CGPoint(x: rect.minX + 0.69067 * rect.width, y: rect.minY + 0.95882 * rect.height), control2: CGPoint(x: rect.minX + 0.69557 * rect.width, y: rect.minY + 0.98894 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.67513 * rect.width, y: rect.minY + 0.99734 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.63852 * rect.width, y: rect.minY + 0.98365 * rect.height), control1: CGPoint(x: rect.minX + 0.66093 * rect.width, y: rect.minY + 1.00291 * rect.height), control2: CGPoint(x: rect.minX + 0.64454 * rect.width, y: rect.minY + 0.99678 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.63681 * rect.width, y: rect.minY + 0.97848 * rect.height), control1: CGPoint(x: rect.minX + 0.63776 * rect.width, y: rect.minY + 0.98199 * rect.height), control2: CGPoint(x: rect.minX + 0.63719 * rect.width, y: rect.minY + 0.98025 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.63685 * rect.width, y: rect.minY + 0.97863 * rect.height))
        path.closeSubpath()

        path.move(to: CGPoint(x: rect.minX + 0.92617 * rect.width, y: rect.minY + 0.39130 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.90141 * rect.width, y: rect.minY + 0.44522 * rect.height), control1: CGPoint(x: rect.minX + 0.94523 * rect.width, y: rect.minY + 0.41099 * rect.height), control2: CGPoint(x: rect.minX + 0.92745 * rect.width, y: rect.minY + 0.44099 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.86577 * rect.width, y: rect.minY + 0.39323 * rect.height), control1: CGPoint(x: rect.minX + 0.87537 * rect.width, y: rect.minY + 0.44944 * rect.height), control2: CGPoint(x: rect.minX + 0.84698 * rect.width, y: rect.minY + 0.41615 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.92617 * rect.width, y: rect.minY + 0.39130 * rect.height), control1: CGPoint(x: rect.minX + 0.88456 * rect.width, y: rect.minY + 0.37031 * rect.height), control2: CGPoint(x: rect.minX + 0.91315 * rect.width, y: rect.minY + 0.37826 * rect.height))
        path.closeSubpath()

        path.move(to: CGPoint(x: rect.minX + 0.24570 * rect.width, y: rect.minY + 0.93317 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.22638 * rect.width, y: rect.minY + 0.97528 * rect.height), control1: CGPoint(x: rect.minX + 0.26060 * rect.width, y: rect.minY + 0.94857 * rect.height), control2: CGPoint(x: rect.minX + 0.24671 * rect.width, y: rect.minY + 0.97199 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.19852 * rect.width, y: rect.minY + 0.93453 * rect.height), control1: CGPoint(x: rect.minX + 0.20604 * rect.width, y: rect.minY + 0.97857 * rect.height), control2: CGPoint(x: rect.minX + 0.18416 * rect.width, y: rect.minY + 0.95242 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.19843 * rect.width, y: rect.minY + 0.93464 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.24101 * rect.width, y: rect.minY + 0.92911 * rect.height), control1: CGPoint(x: rect.minX + 0.20854 * rect.width, y: rect.minY + 0.92223 * rect.height), control2: CGPoint(x: rect.minX + 0.22760 * rect.width, y: rect.minY + 0.91976 * rect.height))
        path.addCurve(to: CGPoint(x: rect.minX + 0.24566 * rect.width, y: rect.minY + 0.93312 * rect.height), control1: CGPoint(x: rect.minX + 0.24271 * rect.width, y: rect.minY + 0.93029 * rect.height), control2: CGPoint(x: rect.minX + 0.24426 * rect.width, y: rect.minY + 0.93163 * rect.height))
        path.addLine(to: CGPoint(x: rect.minX + 0.24570 * rect.width, y: rect.minY + 0.93317 * rect.height))
        path.closeSubpath()

        return path
    }
}

struct SplatInk_Previews: PreviewProvider {
    static var previews: some View {
        SplatInk()
            .scaledToFit()
    }
}
