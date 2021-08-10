//
//  DetailViewController.swift
//  Crypto-Currency
//
//  Created by namtrinh on 10/08/2021.
//

import UIKit
import SafariServices
import Charts

final class DetailViewController: UIViewController {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var symbolLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var titleChangeLabel: UILabel!
    @IBOutlet private weak var historyChartView: LineChartView!
    @IBOutlet private weak var rankLabel: UILabel!
    @IBOutlet private weak var circulatingLabel: UILabel!
    @IBOutlet private weak var totalLabel: UILabel!
    @IBOutlet private weak var volumeLabel: UILabel!
    @IBOutlet private weak var marketCapLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var descriptionHeight: NSLayoutConstraint!
    @IBOutlet private weak var linksTableView: UITableView!
    @IBOutlet private weak var timeSegmented: UISegmentedControl!
    @IBOutlet private weak var readMoreButton: UIButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var tableViewHeight: NSLayoutConstraint!
    
    private var coin: CoinDetail?
    private let repositoryAPI = RepositoryAPI()
    private var historyPrice = [History]()
    private var links = [Link]()
    
    var uuid: String = ""
    private var isLabelAtMaxHeight = false
    private var isLoading = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureChart()
        setUp()
        loadAPI()
    }
    
    private func setUp() {
        linksTableView.delegate = self
        linksTableView.dataSource = self
        linksTableView.register(LinkTableViewCell.nib,
                                forCellReuseIdentifier: LinkTableViewCell.reuseIdentifier)
        
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(self,
                                             action: #selector(handleRefreshControl),
                                             for: .valueChanged)
        
        iconImageView.layer.cornerRadius = 50
    }
    
    @objc func handleRefreshControl() {
        if !isLoading {
            isLoading = true
            loadAPI()
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.scrollView.refreshControl?.endRefreshing()
            }
        }
    }
    
    private func loadData() {
        guard let coin = coin else {
            return
        }
        title = coin.name
        priceLabel.formatPrice(price: coin.price)
        titleChangeLabel.formatChange(percentChange: coin.change)
        descriptionLabel.text = coin.description.htmlToString
        symbolLabel.text = coin.symbol
        marketCapLabel.formatMarketCap(marketCap: coin.marketCap)
        volumeLabel.formatMarketCap(marketCap: coin.volume)
        totalLabel.formatTotal(marketCap: coin.supply.total)
        circulatingLabel.formatTotal(marketCap: coin.supply.circulating)
        rankLabel.text = String(coin.rank)
        let pngUrl = coin.iconUrl.replacingOccurrences(of: "svg", with: "png")
        if let url = URL(string: pngUrl) {
            iconImageView.setImage(from: url)
        }
    }
    
    private func configureChart() {
        historyChartView.rightAxis.enabled = false
        historyChartView.xAxis.labelPosition = .bottom
        historyChartView.xAxis.axisLineColor = .white
        historyChartView.xAxis.setLabelCount(6, force: false)
        historyChartView.animate(xAxisDuration: 0.5)
    }
    
    private func loadChartData() {
        let chartEntry = historyPrice.enumerated().map({ index, historyPrice -> ChartDataEntry in
            guard let price = Double(historyPrice.price) else {
                return ChartDataEntry(x: Double(index), y: 0)
            }
            return ChartDataEntry(x: Double(index), y: price)
        })

        let set = LineChartDataSet(entries: chartEntry, label: "History")
        set.drawCirclesEnabled = false
        set.mode = .linear
        set.lineWidth = 1
        set.setColor(.systemGreen)
        set.fillColor = .systemGreen
        set.fillAlpha = 0.1
        set.drawFilledEnabled = true
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.highlightColor = .systemGray
        
        let data = LineChartData(dataSet: set)
        data.setDrawValues(false)
        historyChartView.data = data
    }
    
    private func loadAPI() {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        repositoryAPI.getDetail(uuid: uuid) { [weak self] coin, error in
            guard let self = self else { return }
            if let error = error {
                self.isLoading = false
                print(error.localizedDescription)
            }
            
            if let coin = coin {
                self.coin = coin
                self.links = coin.links
                dispatchGroup.leave()
            }
        }

        dispatchGroup.enter()
        repositoryAPI.getHistoryPrice(time: "3h") { [weak self] history, error in
            guard let self = self else { return }
            if let error = error {
                self.isLoading = false
                print(error.localizedDescription)
            }
            
            if let history = history {
                self.historyPrice = history
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.isLoading = false
            self.loadData()
            self.loadChartData()
            self.linksTableView.reloadData()
            self.tableViewHeight.constant = CGFloat(60 * self.links.count)
        }
    }
    
    @IBAction func handleReadMoreButton(_ sender: UIButton) {
        if isLabelAtMaxHeight {
            readMoreButton.setTitle("Read more", for: .normal)
            isLabelAtMaxHeight = false
            descriptionHeight.constant = 150
        } else {
            readMoreButton.setTitle("Read less", for: .normal)
            isLabelAtMaxHeight = true
            descriptionHeight.constant = getLabelHeight(text: coin?.description ?? "", width: view.bounds.width, font: descriptionLabel.font)
        }
    }
    
    private func getLabelHeight(text: String, width: CGFloat, font: UIFont) -> CGFloat {
        let label = UILabel(frame: .zero)
        label.frame.size.width = width
        label.font = font
        label.numberOfLines = 0
        label.text = text
        label.sizeToFit()
        return label.frame.size.height
    }
    
    @IBAction func handleTimeSegmented(_ sender: UISegmentedControl) {
        var time = ""
        switch timeSegmented.selectedSegmentIndex {
        case 0:
            time = Select.threeHours.rawValue
        case 1:
            time = Select.twentyFourHours.rawValue
        case 2:
            time = Select.sevenDays.rawValue
        case 4:
            time = Select.thirtyDays.rawValue
        case 5:
            time = Select.threeMonth.rawValue
        default:
            time = Select.threeHours.rawValue
        }
        repositoryAPI.getHistoryPrice(time: time) { [weak self] history, error in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
            }

            if let history = history {
                self.historyPrice = history
                DispatchQueue.main.async {
                    self.loadChartData()
                }
            }
        }
    }
    
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return links.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = linksTableView.dequeueReusableCell(withIdentifier: LinkTableViewCell.reuseIdentifier) as? LinkTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(link: links[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: links[indexPath.row].url) {
            let safariScreen = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            safariScreen.delegate = self
            present(safariScreen, animated: true)
        }
    }
}

extension DetailViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}
