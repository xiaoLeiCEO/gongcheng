//
//  MKMapView+MapViewUtil.h
//  playboy
//
//  Created by 张梦川 on 16/2/29.
//  Copyright © 2016年 yaoyu. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (MapViewUtil)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end
