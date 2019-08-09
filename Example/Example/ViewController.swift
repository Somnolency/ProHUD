//
//  ViewController.swift
//  Example
//
//  Created by xaoxuu on 2018/6/15.
//  Copyright © 2018 Titan Studio. All rights reserved.
//

import UIKit
import ProHUD

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        ProHUD.config { (cfg) in
            cfg.alert { (a) in
                a.duration = 1
                a.forceQuitTimer = 3
//                a.iconSize = .init(width: 20, height: 80)
//                a.reloadData
//                a.iconSize = .init(width: 20, height: 80)
                a.iconForScene { (s) -> UIImage? in
                    return UIImage(named: "icon_download")
                }
                
            }
            cfg.toast { (t) in
//                t.iconSize = .init(width: 300, height: 30)
            }
        }
        
    }
    
    
    @IBAction func test(_ sender: UIButton) {
//        testAlert()
        testToast()
//        testUpdateAction()
//        testGuard()
//        fastGuard()
    }
    
    func testAlert() {
        let a = Alert.push(scene: .loading) { (a) in
            
//            a.update()
        }
        a.update { (vm) in
            vm.add(action: .default, title: "OK", handler: nil)
        }
//        a.update()
//        Alert.push(scene: .loading, title: "Loading") { (a) in
//            a.animate(rotate: true)
//            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
//                a.update { (vm) in
//                    vm.message = "请稍后片刻"
//                }
//                a.animate(rotate: true)
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
//                a.update { (vm) in
//                    vm.message = "请稍后片刻请稍后片刻"
//                }
//                a.animate(rotate: true)
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
//                a.update { (vm) in
//                    vm.scene = .success
//                    vm.add(action: .default, title: "OK") { [weak a] in
//                        a?.pop()
//                    }
//                }
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now()+4) {
//                a.update { (vm) in
//                    vm.update(action: 0, style: .cancel, title: "Cancel", handler: nil)
//                }
//            }
//        }
//        Alert.push(scene: .delete, title: "确认删除", message: "此操作不可撤销！此操作不可撤销！此操作不可撤销！") { (a) in
//            a.identifier = ""
//            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
//                a.update { (vm) in
//                    vm.add(action: .destructive, title: "确认") { [weak a] in
//                        a?.update({ (vm) in
//                            vm.message = "但是饭撒 打算放过"
//                            vm.remove(action: 1)
//                            vm.update(action: 0, style: .destructive, title: "确认", handler: {
//                                a?.pop()
//                            })
//                        })
//                    }
//                    vm.add(action: .cancel, title: "取消", handler: nil)
//                }
//            }
//
//        }
    }
    
    func testDelete() {
        let a = Alert.push(scene: .delete, title: "确认删除", message: "此操作不可撤销")
        a.update { (vm) in
            vm.add(action: .destructive, title: "确认", handler: { [weak a] in
                a?.update { (vm) in
                    vm.scene = .loading
                    vm.title = "正在删除"
                    vm.message = "请稍后片刻"
                    vm.remove(action: 0, 1)
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    a?.update { (vm) in
                        vm.scene = .success
                        vm.title = "删除成功"
                        vm.message = "啊哈哈哈哈"
                        vm.duration = 2
                    }
                    Toast.push(scene: .success, title: "删除成功", message: "aaa")
                }
            })
            vm.add(action: .cancel, title: "取消", handler: nil)
        }
        
        
    }
    func testToast() {
        let t = Toast(scene: .loading, title: "正在加载", message: "请稍候片刻")
        
        let a = Alert.push(scene : .loading, title: "正在加载", message: "请稍候片刻")
        a.didForceQuit {
            t.push()
        }
        
        t.didTapped { [weak t] in
            t?.pop()
            Alert.push(scene: .loading, title: "正在加载", message: "马上就要成功了")
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                Alert.push(scene: .error, title: "加载失败", message: "点击充实") { (vm) in
                    vm.duration = 0
                    vm.identifier = "hehe"
                    let a = vm.vc!
                    vm.add(action: .default, title: "重新加载") {
                        a.vm.scene = .success
                        a.vm.title = "加载成功"
                        a.vm.message = "马上就要成功了aaaa"
                        a.vm.remove(action: 1, 2)
                        a.vm.update(action: 0, style: .default, title: "OK") { [weak a] in
                            a?.pop()
                        }
                        
                    }
                    vm.add(action: .destructive, title: "终止", handler: nil)
                    vm.add(action: .cancel, title: "取消", handler: nil)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    if let a = Alert.alerts("hehe").last {
                        a.update { (vm) in
                            vm.add(action: .cancel, title: "CANCEL", handler: nil)
                        }
                        
                    }
                }
                
                
            }
            
        }
        
        
        
    }
    func testGuard() {
        let g = ProHUD.Guard(title: "请求权限", message: "请打开相机权限开关，否则无法进行测量。")
        
        g.add(title: "呵呵")
        g.add(message: "请打开相机权限开关，否则无法进行测量。请打开相机权限开关，否则无法进行测量。")
        g.add(action: .default, title: "测试弹窗", handler: { [weak self] in
            self?.testToast()
        })
        g.add(action: .destructive, title: "测试删除弹窗", handler: { [weak self] in
            self?.testDelete()
        })
        g.add(action: .cancel, title: "我知道了", handler: nil)
        
        g.push(to: self)
        debugPrint("test: ", g)
    }
    
    func testUpdateAction() {
        let a = Alert.push(scene: .confirm, title: "确认删除", message: "此操作无法撤销")
        a.update { (vm) in
            vm.add(action: .destructive, title: "删除") {
                a.update { (vm) in
                    vm.remove(action: 0, 1)
                    vm.scene = .loading
                    vm.title = "正在删除"
                    vm.message = "请稍后片刻"
                }
            }
            vm.add(action: .cancel, title: "取消", handler: nil)
        }
        
        
        
    }
    
    func fastGuard() {
        Guard.push(to: self) { (vm) in
            vm.add(title: "测试")
            vm.add(message: "测试测试")
            vm.add(action: .default, title: "默认按钮", handler: {
                
            })
            vm.add(action: .cancel, title: "取消", handler: nil)
            vm.vc?.view.backgroundColor = .clear
        }
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        

        
        
    }
    
}

