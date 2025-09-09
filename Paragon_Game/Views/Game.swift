//
//  Game.swift
//  Paragon_Game
//
//  Created by Алкександр Степанов on 30.08.2025.
//

import SwiftUI

struct Game: View {
    @AppStorage("bgNumber") var bgNumber = 2
    @AppStorage("count") var count = 0
    @State private var showSelectPers = false
    @State private var selectedWarriorType: Int? = nil
    @State private var placedWarriors: [Person] = []
    @State private var waitingForCellSelection = false
    @State private var pulseAnimation = false
    @State private var enemyWarriors: [Person] = []
    @State private var gamePhase: GamePhase = .placement
    @State private var selectedWarrior: Person? = nil
    @State private var selectedEnemyWarrior: Person? = nil
    @State private var possibleMoves: [Int] = []
    @State private var possibleTargets: [Int] = []
    @State private var isPlayerTurn = true
    @State private var warriorPulseAnimation = false
    @State private var currentTurnPhase: TurnPhase = .playerTurn
    @State private var allPlayersMoved = false
    @State private var allEnemiesMoved = false
    @State private var yourOpacityArray: [CGFloat] = [0,0,0]
    @State private var enemyOpacityArray: [CGFloat] = [0,0,0]
    @State private var dyingWarriors: Set<UUID> = []
    @State private var movingWarrior: Person? = nil
    @State private var movementTimer: Timer? = nil
    @State private var targetPosition: Pos? = nil
    @State private var currentPosition: Pos? = nil
    @State private var isMoving: Bool = false
    @State private var isCommanderShowing: Bool = false
    @State private var commanderTimer: Timer? = nil
    @State private var xPosition: CGFloat = 0
    @State private var yPosition: CGFloat = 0
    @State private var dragOffset: CGSize = .zero
    @State private var yourCageCoordinates = Arrays.yourCageCoordinates
    @State private var enemyCageCoordinates = Arrays.enemyCageCoordinates
    @State private var yourWarriorsCoordinates = Arrays.yourWarriorsCoordinates
    @State private var enemyWarriorsCoordinates = Arrays.enemyWarriorsCoordinates
    @State private var commandirOpacity: CGFloat = 0
    @State private var textsArray = Arrays.textsArray
    @State private var textIndex = 0
    @State private var youLose = false
    @State private var youWin = false
    @State private var dailyPresented = false
    
    var body: some View {
        ZStack {
            Backgrounds(backgroundNumber: bgNumber)
            HStack {
                Image(.restartButton)
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth*0.08)
                    .onTapGesture {
                        NavGuard.shared.currentScreen = .MENU
                    }
                Spacer()
                Image(.countFrame)
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth*0.25)
                    .overlay(
                        Text("\(count)")
                            .font(.system(size: screenWidth*0.04, weight: .medium))
                            .foregroundStyle(Color.white)
                            .offset(x: -screenWidth*0.02)
                    )
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, screenWidth*0.05)
            .padding(.top)
            
            ForEach(0..<yourCageCoordinates.count, id: \.self) { item in
                Image(.yourCage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth*0.175)
                    .offset(x: yourCageCoordinates[item].x, y: yourCageCoordinates[item].y)
                    .shadow(color: getShadowColor(for: item), 
                           radius: getShadowRadius(for: item))
                    .onTapGesture {
                        handleCellTap(at: item)
                    }
            }
            
            ForEach(0..<enemyCageCoordinates.count, id: \.self) { item in
                Image(.enemyCage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth*0.175)
                    .offset(x: enemyCageCoordinates[item].x, y: enemyCageCoordinates[item].y)
                    .shadow(color: getEnemyShadowColor(for: item), 
                           radius: getEnemyShadowRadius(for: item))
                    .onTapGesture {
                        handleEnemyCellTap(at: item)
                    }
            }
            
            ForEach(Array(placedWarriors.enumerated()), id: \.element.id) { index, warrior in
                if warrior.isAlive || dyingWarriors.contains(warrior.id) {
                ZStack {
                    Image(warrior.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth*0.1)
                        .shadow(color: getShadowColorForWarrior(warrior),
                               radius: getWarriorShadowRadius(warrior))
                        .scaleEffect(selectedWarrior?.id == warrior.id ? 1.1 : 1.0)
                        .opacity(warrior.hasMadeMove ? 0.6 : 1.0)
                        .onTapGesture {
                            if gamePhase == .battle && isPlayerTurn && !warrior.hasMadeMove {
                                selectWarrior(warrior)
                            }
                        }
                    Rectangle()
                        .frame(width: screenWidth*0.12, height: screenWidth*0.2)
                        .foregroundStyle(Color.white.opacity(index < yourOpacityArray.count ? yourOpacityArray[index] : 0.0))
                        .mask(
                            Image(warrior.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth*0.1)
                            )
                    
                    // Health bar
                    VStack(spacing: 2) {
                        // Background bar
//                        Rectangle()
//                            .frame(width: screenWidth*0.08, height: screenWidth*0.01)
//                            .foregroundColor(.black.opacity(0.3))
                        
                        // Health bar
                        GeometryReader { geometry in
                            HStack(spacing: 0) {
                                Rectangle()
                                    .frame(width: geometry.size.width * CGFloat(warrior.health) / CGFloat(warrior.maxHealth), height: geometry.size.height)
                                    .foregroundColor(getHealthBarColor(health: warrior.health, maxHealth: warrior.maxHealth))
                                Spacer(minLength: 0)
                            }
                        }
                        .frame(width: screenWidth*0.08, height: screenWidth*0.01)
                        .background(Color.red.opacity(0.3))
                        .cornerRadius(2)
                    }
                    .offset(y: -screenWidth*0.08)
                }
                .offset(x: getWarriorCoordinates(warrior).x,
                       y: getWarriorCoordinates(warrior).y)
                }
            }
            
            ForEach(Array(enemyWarriors.enumerated()), id: \.element.id) { index, enemy in
                if enemy.isAlive || dyingWarriors.contains(enemy.id) {
                ZStack {
                    Image(enemy.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth*0.1)
                        .shadow(color: possibleTargets.contains(enemy.cellIndex) ? .red : .clear,
                               radius: 10)
                        .onTapGesture {
                            if gamePhase == .battle && possibleTargets.contains(enemy.cellIndex) {
                                attackEnemy(enemy)
                            }
                        }
                    Rectangle()
                        .frame(width: screenWidth*0.12, height: screenWidth*0.2)
                        .foregroundStyle(Color.white.opacity(index < enemyOpacityArray.count ? enemyOpacityArray[index] : 0.0))
                        .mask(
                            Image(enemy.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth*0.1)
                        )
                    
                    // Health bar
                    VStack(spacing: 2) {
                        // Background bar
//                        Rectangle()
//                            .frame(width: screenWidth*0.08, height: screenWidth*0.01)
//                            .foregroundColor(.black.opacity(0.3))
                        
                        // Health bar
                        GeometryReader { geometry in
                            HStack(spacing: 0) {
                                Rectangle()
                                    .frame(width: geometry.size.width * CGFloat(enemy.health) / CGFloat(enemy.maxHealth), height: geometry.size.height)
                                    .foregroundColor(getHealthBarColor(health: enemy.health, maxHealth: enemy.maxHealth))
                                Spacer(minLength: 0)
                            }
                        }
                        .frame(width: screenWidth*0.08, height: screenWidth*0.01)
                        .background(Color.red.opacity(0.3))
                        .cornerRadius(2)
                    }
                    .offset(y: -screenWidth*0.08)
                }
                .offset(x: getWarriorCoordinates(enemy).x,
                       y: getWarriorCoordinates(enemy).y)
                }
            }
            
            Image(.taskButton)
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth*0.1)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .padding(screenWidth*0.03)
                .onTapGesture {
                    dailyPresented.toggle()
                }
            ZStack {
                Image(.commandir)
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth*0.55)
                Image(textsArray[textIndex])
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth*0.23)
                    .offset(x: -screenWidth*0.12, y: -screenWidth*0.122)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .opacity(commandirOpacity)
            if showSelectPers {
                ZStack {
                    Color.black.opacity(0.3)
                    SelectPersForGame(
                        onWarriorSelected: { warriorType in
                            selectedWarriorType = warriorType
                            showSelectPers = false
                            waitingForCellSelection = true
                            startPulseAnimation()
                        }
                    )
                }
            }
            if dailyPresented {
                DailyTask(dailyPresented: $dailyPresented)
            }
            if youWin {
                ZStack {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    YouWin()
                }
            }
            if youLose {
                ZStack {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    YouLose()
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            initializeEnemyWarriors()
            showSelectPers = true
        }
    }
    
    func triggerDamageAnimation(for warrior: Person) {
        print("🟡 Triggering damage animation for \(warrior.id)")
        
        if warrior.isEnemy {
            if let index = enemyWarriors.firstIndex(of: warrior), index < enemyOpacityArray.count {
                print("   Enemy index: \(index)")
                enemyOpacityArray[index] = 1.0
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if index < self.enemyOpacityArray.count && index < self.enemyWarriors.count {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            self.enemyOpacityArray[index] = 0.0
                        }
                    }
                }
            }
        } else {
            if let index = placedWarriors.firstIndex(of: warrior), index < yourOpacityArray.count {
                print("   Player index: \(index)")
                yourOpacityArray[index] = 1.0
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if index < self.yourOpacityArray.count && index < self.placedWarriors.count {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            self.yourOpacityArray[index] = 0.0
                        }
                    }
                }
            }
        }
    }
    
    func showCommander(textIndex: Int, completion: @escaping () -> Void) {
        
        commanderTimer?.invalidate()
        self.textIndex = textIndex
        isCommanderShowing = true
        withAnimation(.easeInOut(duration: 0.5)) {
            commandirOpacity = 1.0
        }
        commanderTimer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                self.commandirOpacity = 0.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isCommanderShowing = false
                completion()
            }
        }
    }
    
    func startSmoothMovement(warrior: Person, to targetIndex: Int) {

        stopMovement()
        movingWarrior = warrior
        isMoving = true
        
        if warrior.isEnemy {
            if getSimpleCrossToPlayerField(from: warrior.cellIndex) == targetIndex {
                targetPosition = yourWarriorsCoordinates[targetIndex]
            } else {
                targetPosition = enemyWarriorsCoordinates[targetIndex]
            }
        } else {
            if getSimpleCrossToEnemyField(from: warrior.cellIndex) == targetIndex {
                targetPosition = enemyWarriorsCoordinates[targetIndex]
            } else {
                targetPosition = yourWarriorsCoordinates[targetIndex]
            }
        }
        
        currentPosition = getWarriorCoordinates(warrior)
        
        movementTimer = Timer.scheduledTimer(withTimeInterval: 0.002, repeats: true) { _ in
            self.updateMovement(warrior: warrior, targetIndex: targetIndex)
        }
    }
    
    func updateMovement(warrior: Person, targetIndex: Int) {
        guard let current = currentPosition, let target = targetPosition else {
            stopMovement()
            return
        }
        
        let speed: CGFloat = 1.5
        let deltaX = target.x - current.x
        let deltaY = target.y - current.y
        let distance = sqrt(deltaX * deltaX + deltaY * deltaY)
        
        if distance <= speed {
            currentPosition = target
            completeMovement(warrior: warrior, targetIndex: targetIndex)
        } else {
            let moveX = (deltaX / distance) * speed
            let moveY = (deltaY / distance) * speed
            
            currentPosition = Pos(x: current.x + moveX, y: current.y + moveY)
        }
    }
    
    func completeMovement(warrior: Person, targetIndex: Int) {
        
        stopMovement()
        let oldCellIndex = warrior.cellIndex
        warrior.moveTo(cellIndex: targetIndex)
        let isMovingToEnemyField = warrior.isEnemy == false && getSimpleCrossToEnemyField(from: oldCellIndex) == targetIndex
        let isMovingToPlayerField = warrior.isEnemy == true && getSimpleCrossToPlayerField(from: oldCellIndex) == targetIndex
        if isMovingToEnemyField {
            warrior.isOnEnemyField = true
        } else if isMovingToPlayerField {
            warrior.isOnEnemyField = false
        }
        warrior.hasMadeMove = true
        endTurn()
    }
    
    func stopMovement() {
        movementTimer?.invalidate()
        movementTimer = nil
        movingWarrior = nil
        isMoving = false
        targetPosition = nil
        currentPosition = nil
    }
    
    func startSmoothMovementForEnemy(enemy: Person, to targetIndex: Int, completion: @escaping () -> Void) {
        
        stopMovement()
        movingWarrior = enemy
        isMoving = true
        if getSimpleCrossToPlayerField(from: enemy.cellIndex) == targetIndex {
            targetPosition = yourWarriorsCoordinates[targetIndex]
        } else {
            targetPosition = enemyWarriorsCoordinates[targetIndex]
        }
        currentPosition = getWarriorCoordinates(enemy)
        movementTimer = Timer.scheduledTimer(withTimeInterval: 0.002, repeats: true) { _ in
            self.updateEnemyMovement(enemy: enemy, targetIndex: targetIndex, completion: completion)
        }
    }
    
    func updateEnemyMovement(enemy: Person, targetIndex: Int, completion: @escaping () -> Void) {
        guard let current = currentPosition, let target = targetPosition else {
            stopMovement()
            completion()
            return
        }
        let speed: CGFloat = 1.5
        let deltaX = target.x - current.x
        let deltaY = target.y - current.y
        let distance = sqrt(deltaX * deltaX + deltaY * deltaY)
        if distance <= speed {
            currentPosition = target
            completeEnemyMovement(enemy: enemy, targetIndex: targetIndex, completion: completion)
        } else {
            let moveX = (deltaX / distance) * speed
            let moveY = (deltaY / distance) * speed
            
            currentPosition = Pos(x: current.x + moveX, y: current.y + moveY)
        }
    }
    
    func completeEnemyMovement(enemy: Person, targetIndex: Int, completion: @escaping () -> Void) {
        
        stopMovement()
        let oldCellIndex = enemy.cellIndex
        enemy.moveTo(cellIndex: targetIndex)
        let isMovingToPlayerField = getSimpleCrossToPlayerField(from: oldCellIndex) == targetIndex
        if isMovingToPlayerField {
            enemy.isOnEnemyField = false
            print("Противник перешел на поле игрока!")
        }
        enemy.hasMadeMove = true
        selectedWarrior = nil
        completion()
    }
    
    func removeDeadWarriors() {
        var indicesToRemove: [Int] = []
        for (index, warrior) in placedWarriors.enumerated().reversed() {
            if !warrior.isAlive {
                indicesToRemove.append(index)
                dyingWarriors.remove(warrior.id)
            }
        }
        for index in indicesToRemove {
            placedWarriors.remove(at: index)
            if index < yourOpacityArray.count {
                yourOpacityArray.remove(at: index)
            }
        }
    }
    
    func isCellOccupied(index: Int) -> Bool {
        let playersOnPlayerField = placedWarriors.contains { $0.cellIndex == index && !$0.isOnEnemyField && $0.isAlive }
        let enemiesOnPlayerField = enemyWarriors.contains { $0.cellIndex == index && !$0.isOnEnemyField && $0.isAlive }
        return playersOnPlayerField || enemiesOnPlayerField
    }
    
    func placeWarrior(at cellIndex: Int) {
        guard let warriorType = selectedWarriorType else { return }
        
        let newWarrior = Person(
            id: UUID(),
            type: warriorType,
            cellIndex: cellIndex
        )
        
        placedWarriors.append(newWarrior)
        waitingForCellSelection = false
        selectedWarriorType = nil
        pulseAnimation = false
        if placedWarriors.count < 3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showSelectPers = true
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                gamePhase = .battle
                startBattlePhase()
            }
        }
    }
    
    func startPulseAnimation() {
        withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            pulseAnimation = true
        }
    }
    
    func initializeEnemyWarriors() {
        enemyWarriors.removeAll()
        enemyOpacityArray = [0,0,0]
        var availablePositions = Array(0..<enemyCageCoordinates.count)
        
        for _ in 0..<3 {
            let randomType = Int.random(in: 1...2)
            let randomIndex = Int.random(in: 0..<availablePositions.count)
            let selectedPosition = availablePositions.remove(at: randomIndex)
            
            let enemy = Person(
                id: UUID(),
                type: randomType,
                cellIndex: selectedPosition,
                isEnemy: true
            )
            enemy.isOnEnemyField = true
            enemyWarriors.append(enemy)
        }
    }
    
    func startBattlePhase() {
        isPlayerTurn = true
        currentTurnPhase = .playerTurn
        selectedWarrior = nil
        possibleMoves = []
        possibleTargets = []
        resetMoveFlags()
        startWarriorPulseAnimation()
    }
    
    func startWarriorPulseAnimation() {
        withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
            warriorPulseAnimation = true
        }
    }
    
    func resetMoveFlags() {
     
        for warrior in placedWarriors {
            warrior.hasMadeMove = false
        }
        for enemy in enemyWarriors {
            enemy.hasMadeMove = false
        }
        allPlayersMoved = false
        allEnemiesMoved = false
    }
    
    func checkTurnCompletion() {
        if currentTurnPhase == .playerTurn {
            allPlayersMoved = placedWarriors.allSatisfy { $0.hasMadeMove || !$0.isAlive }
            
            if allPlayersMoved {
                currentTurnPhase = .enemyTurn
                isPlayerTurn = false
                warriorPulseAnimation = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    startEnemyTurn()
                }
            }
        }
    }
    
    func startEnemyTurn() {
        performEnemyActions()
    }
    
    func performEnemyActions() {
        let aliveEnemies = enemyWarriors.filter { $0.isAlive && !$0.hasMadeMove }
        guard !aliveEnemies.isEmpty else {
            startNewRound()
            return
        }
        
        performNextEnemyAction(enemiesQueue: aliveEnemies, index: 0)
    }
    
    func performNextEnemyAction(enemiesQueue: [Person], index: Int) {
        guard index < enemiesQueue.count else {
            startNewRound()
            return
        }
        
        let enemy = enemiesQueue[index]
        let alivePlayers = placedWarriors.filter { $0.isAlive }
        if let target = alivePlayers.first {
            let enemyPos = getWarriorCoordinates(enemy)
            let targetPos = getWarriorCoordinates(target)
            let distance = sqrt(pow(enemyPos.x - targetPos.x, 2) + pow(enemyPos.y - targetPos.y, 2))
           
            
            if (enemy.isArcher || distance <= 200) && alivePlayers.contains(target) {
                performEnemyAttack(enemy: enemy, target: target) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.performNextEnemyAction(enemiesQueue: enemiesQueue, index: index + 1)
                    }
                }
            } else {
                performEnemyMovement(enemy: enemy, target: target) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.performNextEnemyAction(enemiesQueue: enemiesQueue, index: index + 1)
                    }
                }
            }
        } else {
            enemy.hasMadeMove = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.performNextEnemyAction(enemiesQueue: enemiesQueue, index: index + 1)
            }
        }
    }
    
    func performEnemyMovement(enemy: Person, target: Person, completion: @escaping () -> Void) {
        calculatePossibleMoves(for: enemy)
        
        if !possibleMoves.isEmpty {
            let targetPos = getWarriorCoordinates(target)
            var bestMove = possibleMoves[0]
            var bestDistance = Double.infinity
            
            for moveIndex in possibleMoves {
                let movePos: Pos
                if enemy.isEnemy {
                    if getSimpleCrossToPlayerField(from: enemy.cellIndex) == moveIndex {
                        movePos = yourCageCoordinates[moveIndex]
                    } else {
                        movePos = enemyCageCoordinates[moveIndex]
                    }
                } else {
                    if getSimpleCrossToEnemyField(from: enemy.cellIndex) == moveIndex {
                        movePos = enemyCageCoordinates[moveIndex]
                    } else {
                        movePos = yourCageCoordinates[moveIndex]
                    }
                }
                
                let distance = sqrt(pow(movePos.x - targetPos.x, 2) + pow(movePos.y - targetPos.y, 2))
                
                if distance < bestDistance {
                    bestDistance = distance
                    bestMove = moveIndex
                }
            }
            selectedWarrior = enemy
            
            startSmoothMovementForEnemy(enemy: enemy, to: bestMove, completion: completion)
        } else {
            enemy.hasMadeMove = true
            completion()
        }
    }
    
    func performEnemyAttack(enemy: Person, target: Person, completion: @escaping () -> Void) {
        let targetIndex = placedWarriors.firstIndex(of: target)
        let willDie = target.health <= enemy.damage
        
        withAnimation(.easeInOut(duration: 0.5)) {
            target.takeDamage(enemy.damage)
        }
        
        if !willDie {
            triggerDamageAnimation(for: target)
        } else {
            dyingWarriors.insert(target.id)
            
            if let index = targetIndex {
                if index < yourOpacityArray.count {
                    yourOpacityArray[index] = 1.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeInOut(duration: 0.8)) {
                            if index < self.yourOpacityArray.count {
                                self.yourOpacityArray[index] = 0.0
                            }
                        }
                    }
                }
            }
        }
       
        enemy.hasMadeMove = true
       
        if willDie && (placedWarriors.isEmpty || placedWarriors.allSatisfy({ !$0.isAlive })) {
            showCommander(textIndex: 7) {
                self.gamePhase = .gameOver
                self.youLose = true
            }
        } else {
            let commanderTextIndex = willDie ? 5 : Int.random(in: 3...4)
            showCommander(textIndex: commanderTextIndex) {
                completion()
            }
        }
    }
    
    func startNewRound() {

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.removeDeadWarriors()
            
            self.currentTurnPhase = .playerTurn
            self.isPlayerTurn = true
            self.selectedWarrior = nil
            self.possibleMoves = []
            self.possibleTargets = []
            self.resetMoveFlags()
            
            if self.enemyWarriors.isEmpty || self.enemyWarriors.allSatisfy({ !$0.isAlive }) {
                self.showCommander(textIndex: 6) {
                    self.gamePhase = .gameOver
                    self.youWin = true
                }
                return
            } else if self.placedWarriors.isEmpty || self.placedWarriors.allSatisfy({ !$0.isAlive }) {
                self.showCommander(textIndex: 7) {
                    self.gamePhase = .gameOver
                    self.youLose = true
                }
                return
            }
            self.startWarriorPulseAnimation()
        }
    }
    
    func selectWarrior(_ warrior: Person) {
        if isCommanderShowing { return }
        
        selectedWarrior = warrior
        warriorPulseAnimation = false
        calculatePossibleMoves(for: warrior)
        calculatePossibleTargets(for: warrior)
    }
    
    func calculatePossibleMoves(for warrior: Person) {
        possibleMoves = []
        let currentIndex = warrior.cellIndex
        
        if warrior.isEnemy {
            let currentCellPos = enemyCageCoordinates[currentIndex]
            for i in 0..<enemyCageCoordinates.count {
                if i != currentIndex && !isEnemyCellOccupied(index: i) {
                    let targetCellPos = enemyCageCoordinates[i]
                    let distance = sqrt(pow(currentCellPos.x - targetCellPos.x, 2) + pow(currentCellPos.y - targetCellPos.y, 2))
                    if distance <= 180 {
                        possibleMoves.append(i)
                    }
                }
            }
            
            if let playerCellIndex = getSimpleCrossToPlayerField(from: currentIndex) {
                if !isCellOccupied(index: playerCellIndex) {
                    possibleMoves.append(playerCellIndex)
                    print("Переход добавлен в possibleMoves")
                } else {
                    print("Клетка игрока \(playerCellIndex) занята")
                }
            } else {
                print("Противник на позиции \(currentIndex) НЕ может перейти на поле игрока")
            }
            
        } else {
            let currentCellPos = yourCageCoordinates[currentIndex]
            
            for i in 0..<yourCageCoordinates.count {
                if i != currentIndex && !isCellOccupied(index: i) {
                    let targetCellPos = yourCageCoordinates[i]
                    let distance = sqrt(pow(currentCellPos.x - targetCellPos.x, 2) + pow(currentCellPos.y - targetCellPos.y, 2))
                    if distance <= 180 {
                        possibleMoves.append(i)
                    }
                }
            }
            
            if let enemyCellIndex = getSimpleCrossToEnemyField(from: currentIndex) {
               
                if !isEnemyCellOccupied(index: enemyCellIndex) {
                    possibleMoves.append(enemyCellIndex)
                    print("Переход добавлен в possibleMoves")
                } else {
                    print("Клетка противника \(enemyCellIndex) занята")
                }
            } else {
                print("Игрок на позиции \(currentIndex) НЕ может перейти на поле противника")
            }
        }
        
        print("Possible moves for warrior at \(currentIndex): \(possibleMoves)")
        
        let movesDescription = possibleMoves.map { moveIndex in
            if warrior.isEnemy {
                if getSimpleCrossToPlayerField(from: currentIndex) == moveIndex {
                    return getCellName(for: moveIndex) + " (переход на поле игрока)"
                } else {
                    return getEnemyCellName(for: moveIndex)
                }
            } else {
                if getSimpleCrossToEnemyField(from: currentIndex) == moveIndex {
                    return getEnemyCellName(for: moveIndex) + " (переход на поле противника)"
                } else {
                    return getCellName(for: moveIndex)
                }
            }
        }.joined(separator: ", ")
       
    }
    
    func getCellName(for index: Int) -> String {
        switch index {
        case 0: return "левая верхняя"
        case 1: return "левая центральная"
        case 2: return "левая нижняя"
        case 3: return "центральная верхняя"
        case 4: return "центральная нижняя"
        case 5: return "правая верхняя"
        case 6: return "правая центральная"
        case 7: return "правая нижняя"
        default: return "неизвестная позиция"
        }
    }
    
    func getEnemyCellName(for index: Int) -> String {
        switch index {
        case 0: return "правая верхняя (врага)"
        case 1: return "правая центральная (врага)"
        case 2: return "правая нижняя (врага)"
        case 3: return "центральная верхняя (врага)"
        case 4: return "центральная нижняя (врага)"
        case 5: return "левая верхняя (врага)"
        case 6: return "левая центральная (врага)"
        case 7: return "левая нижняя (врага)"
        default: return "неизвестная позиция (врага)"
        }
    }
    
    func getSimpleCrossToEnemyField(from playerIndex: Int) -> Int? {
       
        switch playerIndex {
        case 5: return 0
        case 6: return 1
        case 7: return 2
        default: return nil
        }
    }
    
    func getSimpleCrossToPlayerField(from enemyIndex: Int) -> Int? {
      
        switch enemyIndex {
        case 0: return 5
        case 1: return 6
        case 2: return 7
        default: return nil
        }
    }
    
    func isEnemyCellOccupied(index: Int) -> Bool {
        let enemiesOnEnemyField = enemyWarriors.contains { $0.cellIndex == index && $0.isOnEnemyField && $0.isAlive }
        let playersOnEnemyField = placedWarriors.contains { $0.cellIndex == index && $0.isOnEnemyField && $0.isAlive }
        return enemiesOnEnemyField || playersOnEnemyField
    }
    
    func getWarriorCoordinates(_ warrior: Person) -> Pos {
        if isMoving && movingWarrior?.id == warrior.id, let current = currentPosition {
            return current
        }
        
        if warrior.isEnemy {
            if warrior.isOnEnemyField {
                return enemyWarriorsCoordinates[warrior.cellIndex]
            } else {
                return yourWarriorsCoordinates[warrior.cellIndex]
            }
        } else {
            if warrior.isOnEnemyField {
                return enemyWarriorsCoordinates[warrior.cellIndex]
            } else {
                return yourWarriorsCoordinates[warrior.cellIndex]
            }
        }
    }
    
    func calculatePossibleTargets(for warrior: Person) {
        possibleTargets = []
        
        if warrior.isArcher {
            if warrior.isEnemy {
                for player in placedWarriors {
                    if player.isAlive {
                        possibleTargets.append(player.cellIndex)
                    }
                }
            } else {
                for enemy in enemyWarriors {
                    if enemy.isAlive {
                        possibleTargets.append(enemy.cellIndex)
                    }
                }
            }
        } else {
            let currentPos = getWarriorCoordinates(warrior)
            
            if warrior.isEnemy {
                for player in placedWarriors {
                    if player.isAlive {
                        let playerPos = getWarriorCoordinates(player)
                        let distance = sqrt(pow(currentPos.x - playerPos.x, 2) + pow(currentPos.y - playerPos.y, 2))
                        
                        if distance <= 200 {
                            possibleTargets.append(player.cellIndex)
                        }
                    }
                }
            } else {
                for enemy in enemyWarriors {
                    if enemy.isAlive {
                        let enemyPos = getWarriorCoordinates(enemy)
                        let distance = sqrt(pow(currentPos.x - enemyPos.x, 2) + pow(currentPos.y - enemyPos.y, 2))
                        
                        if distance <= 200 {
                            possibleTargets.append(enemy.cellIndex)
                        }
                    }
                }
            }
        }
    }
    
    func getShadowColor(for index: Int) -> Color {
        if waitingForCellSelection && !isCellOccupied(index: index) {
            return .white
        }
        if possibleMoves.contains(index) {
            return .blue
        }
        return .clear
    }
    
    func getShadowRadius(for index: Int) -> CGFloat {
        if waitingForCellSelection && !isCellOccupied(index: index) {
            return 20
        }
        if possibleMoves.contains(index) {
            return 20
        }
        return 5
    }
    
    func getEnemyShadowColor(for index: Int) -> Color {
        if possibleMoves.contains(index) {
            return .blue
        }
        if possibleTargets.contains(index) {
            return .red
        }
        return .clear
    }
    
    func getEnemyShadowRadius(for index: Int) -> CGFloat {
        if possibleMoves.contains(index) || possibleTargets.contains(index) {
            return 20
        }
        return 5
    }
    
    func getShadowColorForWarrior(_ warrior: Person) -> Color {
        if gamePhase == .battle && isPlayerTurn && selectedWarrior?.id != warrior.id && !warrior.hasMadeMove {
            return .blue
        }
        return .clear
    }
    
    func getWarriorShadowRadius(_ warrior: Person) -> CGFloat {
        if warriorPulseAnimation && !warrior.hasMadeMove {
            return 15
        }
        return 5
    }
    
    func handleCellTap(at index: Int) {
        if isCommanderShowing { return }
        
        if waitingForCellSelection && !isCellOccupied(index: index) {
            placeWarrior(at: index)
        } else if gamePhase == .battle && possibleMoves.contains(index) {
            moveWarrior(to: index)
        }
    }
    
    func handleEnemyCellTap(at index: Int) {
        if isCommanderShowing { return }
        
        if gamePhase == .battle && possibleTargets.contains(index) {
            attackEnemy(enemyWarriors.first(where: { $0.cellIndex == index })!)
        } else if gamePhase == .battle && possibleMoves.contains(index) {
            moveWarrior(to: index)
        }
    }
    
    func moveWarrior(to index: Int) {
        guard let warrior = selectedWarrior else { return }
        
        startSmoothMovement(warrior: warrior, to: index)
        selectedWarrior = nil
        possibleMoves = []
        possibleTargets = []
    }
    
    func attackEnemy(_ enemy: Person) {
        guard let attacker = selectedWarrior else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            // Атакующий увеличивается
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let enemyIndex = enemyWarriors.firstIndex(of: enemy)
            let willDie = enemy.health <= attacker.damage
            enemy.takeDamage(attacker.damage)
            if !willDie {
                triggerDamageAnimation(for: enemy)
            } else {
                dyingWarriors.insert(enemy.id)
                
                if let index = enemyIndex {
                    if index < enemyOpacityArray.count {
                        enemyOpacityArray[index] = 1.0
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation(.easeInOut(duration: 0.8)) {
                                if index < self.enemyOpacityArray.count {
                                    self.enemyOpacityArray[index] = 0.0
                                }
                            }
                        }
                    }
                }
            }
            attacker.hasMadeMove = true
            withAnimation(.easeInOut(duration: 0.2)) {
                
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + (willDie ? 1.0 : 0.0)) {
                var indicesToRemove: [Int] = []
                for (index, enemy) in self.enemyWarriors.enumerated().reversed() {
                    if !enemy.isAlive {
                        indicesToRemove.append(index)
                        self.dyingWarriors.remove(enemy.id)
                    }
                }
                for index in indicesToRemove {
                    self.enemyWarriors.remove(at: index)
                    if index < self.enemyOpacityArray.count {
                        self.enemyOpacityArray.remove(at: index)
                    }
                }
                if self.enemyWarriors.isEmpty || self.enemyWarriors.allSatisfy({ !$0.isAlive }) {
                    self.showCommander(textIndex: 6) {
                        self.gamePhase = .gameOver
                        self.youWin = true
                    }
                } else {
                    let commanderTextIndex = willDie ? 0 : Int.random(in: 1...2)
                    self.showCommander(textIndex: commanderTextIndex) {
                        self.endTurn()
                    }
                }
            }
        }
    }
    
    func endTurn() {
        selectedWarrior = nil
        possibleMoves = []
        possibleTargets = []
        checkTurnCompletion()
    }
    
    func getHealthBarColor(health: Int, maxHealth: Int) -> Color {
        let healthPercentage = Double(health) / Double(maxHealth)
        
        if healthPercentage > 0.6 {
            return .green
        } else if healthPercentage > 0.3 {
            return .yellow
        } else {
            return .red
        }
    }
    
}

enum GamePhase {
    case placement
    case battle
    case gameOver
}

enum TurnPhase {
    case playerTurn
    case enemyTurn
    case turnTransition
}

class Person: ObservableObject, Identifiable, Equatable {
    let id: UUID
    @Published var type: Int
    @Published var cellIndex: Int
    @Published var health: Int
    @Published var maxHealth: Int
    @Published var damage: Int
    @Published var isEnemy: Bool
    @Published var isAlive: Bool = true
    @Published var hasMadeMove: Bool = false
    @Published var isOnEnemyField: Bool = false
    @Published var whiteOpacity: CGFloat = 0
    
    init(id: UUID = UUID(), type: Int, cellIndex: Int, isEnemy: Bool = false) {
        self.id = id
        self.type = type
        self.cellIndex = cellIndex
        self.isEnemy = isEnemy
        
        switch type {
        case 1:
            self.health = 100
            self.maxHealth = 100
            self.damage = 30
        case 2:
            self.health = 70
            self.maxHealth = 70
            self.damage = 25
        default:
            self.health = 80
            self.maxHealth = 80
            self.damage = 20
        }
    }
    
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.id == rhs.id
    }
    
    func takeDamage(_ amount: Int) {
        let oldHealth = health
        health = max(0, health - amount)
        isAlive = health > 0
        
        print("💀 takeDamage: \(oldHealth) -> \(health), isAlive: \(isAlive)")
        
        if !isAlive {
            print("💀 ПЕРСОНАЖ УМЕР! ID: \(id)")
        }
    }
    
    func moveTo(cellIndex: Int) {
        self.cellIndex = cellIndex
    }
    

    
    var imageName: String {
        if isEnemy {
            return type == 1 ? "enemyWarrior" : "enemyArcher"
        } else {
            switch type {
            case 1: return "yourWarrior"
            case 2: return "yourArcher"
            case 3: return "yourWarrior_2"
            case 4: return "yourArcher_2"
            case 5: return "yourArcher_3"
            default: return "yourWarrior"
            }
        }
    }
    
    var isArcher: Bool {
        return type == 2 || type == 4 || type == 5
    }
}

struct SelectPersForGame: View {
    @State private var persLevelData = UserDefaults.standard.array(forKey: "persLevelData") as? [Int] ?? [1,1]
    @State private var persInfoData = UserDefaults.standard.array(forKey: "persInfoData") as? [Int] ?? [1,2]
    @State private var showImprove = false
    @State private var persIndex = 0
    let onWarriorSelected: (Int) -> Void
    
    var body: some View {
        ZStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: screenWidth*0.04) {
                    Spacer()
                    ForEach(0..<persInfoData.count, id: \.self) { item in
                        ZStack {
                            Image(.selectPersFrame)
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth*0.2)
                            Image(whatPers(item: persInfoData[item]))
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth*0.15)
                                .onTapGesture {
                                    onWarriorSelected(persInfoData[item])
                                }
                            Image(persLevelData[item] == 1 ? "level1Plate" : "level2Plate")
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth*0.07)
                                .overlay(
                                    Text("LVL \(persLevelData[item])")
                                        .foregroundStyle(Color.white)
                                        .font(.system(size: screenWidth*0.02, weight: .bold))
                                        
                                )
                                .offset(x: -screenWidth*0.09, y: -screenWidth*0.115)
                            Image(.persButton)
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth*0.15)
                                .overlay(
                                    Text("Improve")
                                        .foregroundStyle(Color.white)
                                        .font(.system(size: screenWidth*0.02, weight: .bold))
                                )
                                .offset(y: screenWidth*0.1)
                                .onTapGesture {
                                    persIndex = item
                                    showImprove.toggle()
                                }
                        }
                    }
                }
                .padding(.leading, persInfoData.count == 2 ? screenWidth*0.2 : persInfoData.count == 3 ? screenWidth*0.1 : 0 )
                .padding(.trailing, screenWidth*0.05)
                .padding(.vertical)
            }
            if showImprove {
                ZStack {
                    Color.black.opacity(0.3)
                    UpdatePers(showImprove: $showImprove, persIndex: $persIndex)
                }
            }
        }
    }
    
    func whatPers(item: Int) -> String {
        switch item {
        case 1:
            return "yourWarrior"
        case 2:
            return "yourArcher"
        case 3:
            return "yourWarrior_2"
        case 4:
            return "yourArcher_2"
        case 5:
            return "yourArcher_3"
        default:
            return ""
        }
    }
}

#Preview {
    Game()
}
