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
			return 5
		case 1:
			return 5
		default:
			return 0
		}
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0:
			return "Still"
		case 1:
			return "Animated"
		default:
			return nil
		}
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.accessoryType = .disclosureIndicator
		let text: String? = {
			switch (indexPath.section, indexPath.row) {
			case (0, 0):
				return "Draw a star"
			case (0, 1):
				return "Draw emitting lines"
			case (0, 2):
				return "Draw a star and emitting lines"
			case (0, 3):
				return "Draw a wave"
			case (0, 4):
				return "Draw stars"
			case (1, 0):
				return "Draw a star"
			case (1, 1):
				return "Draw emitting lines"
			case (1, 2):
				return "Draw a star and emitting lines"
			case (1, 3):
				return "Draw a wave"
			case (1, 4):
				return "Draw stars"
			default:
				return nil
			}
		}()
		cell.textLabel?.text = text
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let contoller:UIViewController? = {
			switch (indexPath.section, indexPath.row) {
			case (0, 0):
				return StarViewController()
			case (0, 1):
				return EmitViewController()
			case (0, 2):
				return StarAndEmitViewController()
			case (0, 3):
				return WaveViewController()
			case (0, 4):
				return MultipleStarsViewController()
			case (1, 0):
				return AnimatedStarViewController()
			case (1, 1):
				return AnimatedEmitViewController()
			case (1, 2):
				return AnimatedStarAndEmitViewController()
			case (1, 3):
				return AnimatedWaveViewController()
			case (1, 4):
				return AnimatedMultipleStarsViewController()
			default:
				return nil
			}
		}()
		if let contoller = contoller {
			self.navigationController?.pushViewController(contoller, animated: true)
		}
	}
}



