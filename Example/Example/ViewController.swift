import UIKit

class ViewController: UITableViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		self.title = "Examples"
	}

	override func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 4
		default:
			return 0
		}
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.accessoryType = .disclosureIndicator
		switch (indexPath.section, indexPath.row) {
		case (0, 0):
			cell.textLabel?.text = "Draw a star"
		case (0, 1):
			cell.textLabel?.text = "Draw emitting lines"
		case (0, 2):
			cell.textLabel?.text = "Draw a star and emitting lines"
		case (0, 3):
			cell.textLabel?.text = "Draw a wave"
		default:
			break
		}
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch (indexPath.section, indexPath.row) {
		case (0, 0):
			navigationController?.pushViewController(StarViewController(), animated: true)
		case (0, 1):
			navigationController?.pushViewController(EmitViewController(), animated: true)
		case (0, 2):
			navigationController?.pushViewController(StarAndEmitViewController(), animated: true)
		case (0, 3):
			navigationController?.pushViewController(WaveViewController(), animated: true)
		default:
			break
		}
	}
}

