//
//  ViewController.swift
//  TableView
//
//  Created by 차유민 on 2023/03/08.
//

import UIKit

class ViewController: UIViewController {
   
    var moviesArray: [Movie] = []
    
    var movieDataManager = DataManager()
    
    

    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        setUpDatas()
        title = "영화목록"
        
//        tableView.register(<#T##nib: UINib?##UINib?#>, forCellReuseIdentifier: <#T##String#>)
//         코드로 짜면 셀을 등록하는 과정이 필요, 이번 수업에서는 스토리 보드로 짰기 때문에 생략할 수 있었던 것
    }
    
    func setUpTableView() {
        //델리게이트 패턴의 대리자 설정
        tableView.dataSource = self
        tableView.delegate = self
        //셀의 높이 설정
        tableView.rowHeight = 120
    }
    
    func setUpDatas() {
        movieDataManager.makeMovieData() // 일반적으로는 서버에 요청
        moviesArray = movieDataManager.getMovieData() // 데이터 받아서 뷰컨의 배열에 저장
    }

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        movieDataManager.updateMovieData()
        //다시 배열에 받아서 뷰컨에 저장해주는 코드
        moviesArray = movieDataManager.getMovieData()
        tableView.reloadData()
        
    }
    
}







extension ViewController: UITableViewDataSource {
    // 1) 테이블뷰에 몇개의 데이터를 표시할 것인지(셀이 몇개인지)를 뷰컨트롤러에게 물어봄
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return moviesArray.count
    }
    
    // 2) 셀의 구성(셀에 표시하고자 하는 데이터 표시)을 뷰컨트롤러에게 물어봄
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //원래는 cell의 속성이 UITableViewCell이였는데 타입케스팅을 해줘야 MovieCell이 된다. (해줘야함)
        //어쩌피 실제 힙 메모리에 올라가있는건 MovieCell이지만 애플 자체에서 리턴 값이 UITableView로 올라가게 만들어 놓았기 때문에 타입캐스팅을 해주는 것이다.
        
        // 공식처럼 쓰는 코드,,
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
      
        let movie = moviesArray[indexPath.row]
        
        
        cell.mainImageView.image = movie.movieImage
        cell.movieNameLabel.text = movie.movieName
        cell.descriptionLabel.text = movie.movieDescription
        cell.selectionStyle = .none
        
        return cell
    } // 셀이 형태를 지정해주는 것
    
}


extension ViewController: UITableViewDelegate {
    
    // 셀이 선택이 되었을 때 어떤 동작을 할 것인지 뷰컨트롤러에게 물어봄
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 세그웨이 실행
        performSegue(withIdentifier: "toDetail", sender: indexPath)
        
        
        
    }
    
    // prepare 세그웨이(데이터 전달)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
         let detailVC = segue.destination as! DetailViewController // destination : 다음화면
         let index = sender as! IndexPath
            
            //배열에서 아이탬을 꺼내서, 다음화면으로 전달
            detailVC.movieData = moviesArray[index.row]
            
        }
        
        
    }
    
}

