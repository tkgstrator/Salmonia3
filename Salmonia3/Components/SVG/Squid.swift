//
//  Squid.swift
//  Salmonia3
//
//  Created by devonly on 2022/07/02.
//  Copyright © 2022 Magi Corporation. All rights reserved.
//

import SwiftUI

struct Squid: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.50065*width, y: 0))
        path.addCurve(to: CGPoint(x: 0.0484*width, y: 0.55584*height), control1: CGPoint(x: 0.42441*width, y: 0), control2: CGPoint(x: 0.01687*width, y: 0.43696*height))
        path.addCurve(to: CGPoint(x: 0.22842*width, y: 0.61998*height), control1: CGPoint(x: 0.06297*width, y: 0.61039*height), control2: CGPoint(x: 0.22842*width, y: 0.61998*height))
        path.addCurve(to: CGPoint(x: 0.26674*width, y: 0.799*height), control1: CGPoint(x: 0.22842*width, y: 0.61998*height), control2: CGPoint(x: 0.28351*width, y: 0.73946*height))
        path.addCurve(to: CGPoint(x: 0.30486*width, y: 0.97642*height), control1: CGPoint(x: 0.26016*width, y: 0.82218*height), control2: CGPoint(x: 0.1913*width, y: 0.9045*height))
        path.addCurve(to: CGPoint(x: 0.37212*width, y: 0.85495*height), control1: CGPoint(x: 0.30486*width, y: 0.97642*height), control2: CGPoint(x: 0.36873*width, y: 0.93626*height))
        path.addCurve(to: CGPoint(x: 0.43858*width, y: height), control1: CGPoint(x: 0.37172*width, y: 0.86334*height), control2: CGPoint(x: 0.36653*width, y: 0.97343*height))
        path.addCurve(to: CGPoint(x: 0.50085*width, y: 0.86254*height), control1: CGPoint(x: 0.43858*width, y: height), control2: CGPoint(x: 0.50065*width, y: 0.98681*height))
        path.addCurve(to: CGPoint(x: 0.56312*width, y: height), control1: CGPoint(x: 0.50085*width, y: 0.98681*height), control2: CGPoint(x: 0.56312*width, y: height))
        path.addCurve(to: CGPoint(x: 0.62958*width, y: 0.85495*height), control1: CGPoint(x: 0.63516*width, y: 0.97343*height), control2: CGPoint(x: 0.62998*width, y: 0.86334*height))
        path.addCurve(to: CGPoint(x: 0.69683*width, y: 0.97642*height), control1: CGPoint(x: 0.63297*width, y: 0.93646*height), control2: CGPoint(x: 0.69683*width, y: 0.97642*height))
        path.addCurve(to: CGPoint(x: 0.73495*width, y: 0.799*height), control1: CGPoint(x: 0.8104*width, y: 0.9045*height), control2: CGPoint(x: 0.74154*width, y: 0.82218*height))
        path.addCurve(to: CGPoint(x: 0.77327*width, y: 0.61998*height), control1: CGPoint(x: 0.71799*width, y: 0.73946*height), control2: CGPoint(x: 0.77327*width, y: 0.61998*height))
        path.addCurve(to: CGPoint(x: 0.95329*width, y: 0.55584*height), control1: CGPoint(x: 0.77327*width, y: 0.61998*height), control2: CGPoint(x: 0.93892*width, y: 0.61039*height))
        path.addCurve(to: CGPoint(x: 0.50065*width, y: 0), control1: CGPoint(x: 0.98463*width, y: 0.43696*height), control2: CGPoint(x: 0.57709*width, y: 0))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.62279*width, y: 0.70709*height))
        path.addCurve(to: CGPoint(x: 0.50065*width, y: 0.67453*height), control1: CGPoint(x: 0.54456*width, y: 0.70709*height), control2: CGPoint(x: 0.53737*width, y: 0.67453*height))
        path.addCurve(to: CGPoint(x: 0.37851*width, y: 0.70709*height), control1: CGPoint(x: 0.46393*width, y: 0.67453*height), control2: CGPoint(x: 0.45674*width, y: 0.70709*height))
        path.addCurve(to: CGPoint(x: 0.22942*width, y: 0.53427*height), control1: CGPoint(x: 0.29608*width, y: 0.70709*height), control2: CGPoint(x: 0.22942*width, y: 0.62977*height))
        path.addCurve(to: CGPoint(x: 0.40325*width, y: 0.36404*height), control1: CGPoint(x: 0.22942*width, y: 0.44436*height), control2: CGPoint(x: 0.2859*width, y: 0.35385*height))
        path.addCurve(to: CGPoint(x: 0.50065*width, y: 0.39381*height), control1: CGPoint(x: 0.46233*width, y: 0.36903*height), control2: CGPoint(x: 0.4779*width, y: 0.39381*height))
        path.addCurve(to: CGPoint(x: 0.59804*width, y: 0.36404*height), control1: CGPoint(x: 0.5234*width, y: 0.39381*height), control2: CGPoint(x: 0.53897*width, y: 0.36903*height))
        path.addCurve(to: CGPoint(x: 0.77188*width, y: 0.53427*height), control1: CGPoint(x: 0.7154*width, y: 0.35385*height), control2: CGPoint(x: 0.77188*width, y: 0.44436*height))
        path.addCurve(to: CGPoint(x: 0.62279*width, y: 0.70709*height), control1: CGPoint(x: 0.77208*width, y: 0.62977*height), control2: CGPoint(x: 0.70522*width, y: 0.70709*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.61561*width, y: 0.38282*height))
        path.addCurve(to: CGPoint(x: 0.50065*width, y: 0.46054*height), control1: CGPoint(x: 0.56491*width, y: 0.38282*height), control2: CGPoint(x: 0.52121*width, y: 0.41459*height))
        path.addCurve(to: CGPoint(x: 0.38569*width, y: 0.38282*height), control1: CGPoint(x: 0.48009*width, y: 0.41459*height), control2: CGPoint(x: 0.43638*width, y: 0.38282*height))
        path.addCurve(to: CGPoint(x: 0.25816*width, y: 0.51968*height), control1: CGPoint(x: 0.31524*width, y: 0.38282*height), control2: CGPoint(x: 0.25816*width, y: 0.44416*height))
        path.addCurve(to: CGPoint(x: 0.38569*width, y: 0.65654*height), control1: CGPoint(x: 0.25816*width, y: 0.5952*height), control2: CGPoint(x: 0.31524*width, y: 0.65654*height))
        path.addCurve(to: CGPoint(x: 0.50065*width, y: 0.57882*height), control1: CGPoint(x: 0.43638*width, y: 0.65654*height), control2: CGPoint(x: 0.48009*width, y: 0.62478*height))
        path.addCurve(to: CGPoint(x: 0.61561*width, y: 0.65654*height), control1: CGPoint(x: 0.52121*width, y: 0.62478*height), control2: CGPoint(x: 0.56491*width, y: 0.65654*height))
        path.addCurve(to: CGPoint(x: 0.74294*width, y: 0.51968*height), control1: CGPoint(x: 0.68586*width, y: 0.65654*height), control2: CGPoint(x: 0.74294*width, y: 0.5952*height))
        path.addCurve(to: CGPoint(x: 0.61561*width, y: 0.38282*height), control1: CGPoint(x: 0.74314*width, y: 0.44416*height), control2: CGPoint(x: 0.68606*width, y: 0.38282*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.39567*width, y: 0.54665*height))
        path.addCurve(to: CGPoint(x: 0.32023*width, y: 0.47532*height), control1: CGPoint(x: 0.35396*width, y: 0.54665*height), control2: CGPoint(x: 0.32023*width, y: 0.51469*height))
        path.addCurve(to: CGPoint(x: 0.39567*width, y: 0.404*height), control1: CGPoint(x: 0.32023*width, y: 0.43596*height), control2: CGPoint(x: 0.35396*width, y: 0.404*height))
        path.addCurve(to: CGPoint(x: 0.47111*width, y: 0.47532*height), control1: CGPoint(x: 0.43738*width, y: 0.404*height), control2: CGPoint(x: 0.47111*width, y: 0.43596*height))
        path.addCurve(to: CGPoint(x: 0.39567*width, y: 0.54665*height), control1: CGPoint(x: 0.47091*width, y: 0.51469*height), control2: CGPoint(x: 0.43718*width, y: 0.54665*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.60583*width, y: 0.54665*height))
        path.addCurve(to: CGPoint(x: 0.53039*width, y: 0.47532*height), control1: CGPoint(x: 0.56411*width, y: 0.54665*height), control2: CGPoint(x: 0.53039*width, y: 0.51469*height))
        path.addCurve(to: CGPoint(x: 0.60583*width, y: 0.404*height), control1: CGPoint(x: 0.53039*width, y: 0.43596*height), control2: CGPoint(x: 0.56411*width, y: 0.404*height))
        path.addCurve(to: CGPoint(x: 0.68127*width, y: 0.47532*height), control1: CGPoint(x: 0.64754*width, y: 0.404*height), control2: CGPoint(x: 0.68127*width, y: 0.43596*height))
        path.addCurve(to: CGPoint(x: 0.60583*width, y: 0.54665*height), control1: CGPoint(x: 0.68127*width, y: 0.51469*height), control2: CGPoint(x: 0.64754*width, y: 0.54665*height))
        path.closeSubpath()
        return path
    }
}

struct Squid_Previews: PreviewProvider {
    static var previews: some View {
        Squid()
            .scaledToFit()
    }
}
