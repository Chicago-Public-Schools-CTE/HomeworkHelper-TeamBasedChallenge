import SwiftUI
import Combine
import AVFoundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(AudioToolbox)
import AudioToolbox
#endif

// Homework Helper — seeded challenge app for accessibility audit.
// Runs as a single file in Swift Playgrounds (iPad) or Xcode (Mac):
// paste over ContentView.swift in a blank SwiftUI App project.

// MARK: - Models

struct Assignment: Identifiable {
    let id = UUID()
    var title: String
    var course: String
    var due: String
    var priority: Int      // 1 = high, 2 = medium, 3 = low
    var done: Bool = false
}

// MARK: - Audio Note Player

final class AudioNotePlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var isPlaying: Bool = false
    private var player: AVAudioPlayer?

    func togglePlay() {
        if let player, player.isPlaying {
            player.stop()
            isPlaying = false
            return
        }

        guard let audioURL = Bundle.main.url(
            forResource: "Talk by Steven Jobs - IDCA 1983",
            withExtension: "mp3"
        ) else {
            return
        }

        do {
            let player = try AVAudioPlayer(contentsOf: audioURL)
            player.delegate = self
            player.prepareToPlay()
            self.player = player
            isPlaying = player.play()
        } catch {
            isPlaying = false
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async {
            self.isPlaying = false
        }
    }
}

// MARK: - Main ContentView

struct ContentView: View {
    @State private var selectedTab = 0

    // Shared State
    @State private var assignments: [Assignment] = [
        Assignment(title: "Read ch. 4 and answer questions", course: "Biology", due: "Tomorrow", priority: 1),
        Assignment(title: "Unit circle worksheet", course: "Algebra 2", due: "Thursday", priority: 2),
        Assignment(title: "Lab safety quiz", course: "Biology", due: "Friday", priority: 2),
        Assignment(title: "Draft personal essay", course: "English", due: "Next Monday", priority: 3)
    ]

    @State private var showingAddModal = false
    @State private var newTitle = ""
    @State private var newCourse = ""
    @State private var errorMessage = ""

    let tips = [
        "Break big assignments into 25-minute chunks.",
        "Start with the assignment you're dreading most.",
        "Put your phone in another room while you study.",
        "Re-read the directions before you turn anything in."
    ]
    @State private var tipIndex = 0
    @State private var tipPulse = false
    let tipTimer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    @State private var alertFlash = false
    let alertTimer = Timer.publish(every: 0.35, on: .main, in: .common).autoconnect()

    @State private var sessionDuration = 60
    @State private var secondsLeft = 60
    @State private var timerRunning = false
    @State private var isChimeEnabled = true
    let studyTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    @StateObject private var audioPlayer = AudioNotePlayer()

    @State private var voiceNoteCaptured = false
    @State private var handsFreeMode = false
    @State private var questionAsked = false
    @State private var helpRequestedID: Assignment.ID?
    @State private var dailyCheckInDone = false
    @State private var captionsEnabled = false

    private var cardBackground: Color {
        #if canImport(UIKit)
        return Color(uiColor: .secondarySystemBackground)
        #elseif canImport(AppKit)
        return Color(nsColor: .windowBackgroundColor)
        #else
        return Color.secondary.opacity(0.12)
        #endif
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            homeTab
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)

            todoTab
                .tabItem {
                    Label("To-Do", systemImage: "checklist")
                }
                .tag(1)

            timerTab
                .tabItem {
                    Label("Timer", systemImage: "timer")
                }
                .tag(2)

            audioNotesTab
                .tabItem {
                    Label("Audio Notes", systemImage: "waveform")
                }
                .tag(3)
        }
        .sheet(isPresented: $showingAddModal) {
            addAssignmentModal
        }
        .onReceive(tipTimer) { _ in
            tipIndex = (tipIndex + 1) % tips.count
        }
        .onReceive(alertTimer) { _ in
            alertFlash.toggle()
        }
        .onReceive(studyTimer) { _ in
            tick()
        }
    }

    // MARK: - Tab 0: Home / Dashboard

    var homeTab: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    urgentAlertBanner

                    classAnnouncementBanner

                    tipsBanner

                    dailyCheckInBanner

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Today's Overview")
                            .font(.headline)

                        HStack(spacing: 14) {
                            overviewCard(
                                title: "Pending Tasks",
                                value: "\(assignments.filter { !$0.done }.count)",
                                icon: "checklist",
                                color: .orange
                            )

                            overviewCard(
                                title: "Study Goal",
                                value: "60s Demo",
                                icon: "timer",
                                color: .blue
                            )
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Voice Memo")
                            .font(.headline)

                        HStack(spacing: 14) {
                            Image(systemName: "mic.fill")
                                .font(.title2)
                                .foregroundStyle(.blue)
                                .frame(width: 44, height: 44)
                                .background(Color.blue.opacity(0.15))
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 3) {
                                Text("Talk by Steven Jobs — IDCA 1983")
                                    .font(.subheadline.bold())
                                Text("Listen in the Audio Notes tab")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding()
            }
            .navigationTitle("Homework Helper")
        }
    }

    func overviewCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(color)
                Spacer()
                Text(value)
                    .font(.title2.bold())
            }
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    var urgentAlertBanner: some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
            Text("URGENT: Final Exam review sessions begin tomorrow!")
                .font(.caption.bold())
        }
        .foregroundStyle(alertFlash ? Color.white : Color.black)
        .padding(10)
        .frame(maxWidth: .infinity)
        .background(alertFlash ? Color.red : Color.yellow)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    var tipsBanner: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Study Tip")
                .font(.caption.bold())
                .foregroundStyle(.blue)

            Text(tips[tipIndex])
                .font(.subheadline)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.blue.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .scaleEffect(tipPulse ? 1.03 : 1.0)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.7).repeatForever(autoreverses: true)) {
                tipPulse = true
            }
        }
    }

    var classAnnouncementBanner: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Class Announcement")
                    .font(.headline)
                Spacer()
                Button {
                    playAnnouncementChime()
                } label: {
                    Image(systemName: "bell.fill")
                        .foregroundStyle(.orange)
                }
            }
            Text("Tap the bell to hear today's announcement from your teacher.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    var dailyCheckInBanner: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Daily Check-In")
                .font(.caption.bold())
                .foregroundStyle(.purple)

            Text(dailyCheckInDone ? "Thanks for checking in today!" : "Tap the mic and tell us how studying is going today.")
                .font(.subheadline)

            if !dailyCheckInDone {
                Button {
                    dailyCheckInDone = true
                } label: {
                    HStack {
                        Image(systemName: "mic.fill")
                        Text("Record check-in")
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }
                .buttonStyle(.borderedProminent)
                .tint(.purple)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.purple.opacity(0.12))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - Tab 1: To-Do List

    var todoTab: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    newAssignmentButton

                    assignmentsListSection
                }
                .padding()
            }
            .navigationTitle("To-Do List")
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        showingAddModal = true
                    } label: {
                        Image(systemName: "plus")
                    }

                    Button {
                        assignments.sort { $0.priority < $1.priority }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }

                    Button {
                        assignments.removeAll()
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
    }

    var newAssignmentButton: some View {
        Button {
            showingAddModal = true
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "plus.circle.fill")
                    .font(.title3)
                Text("New Assignment")
                    .font(.headline)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
            }
            .padding()
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }

    var assignmentsListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Active Tasks")
                    .font(.headline)
                Spacer()
                Text("\(assignments.filter { !$0.done }.count) remaining")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if assignments.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "tray")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text("No assignments scheduled.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
                .background(cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            } else {
                ForEach($assignments) { $item in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 12) {
                            Image(systemName: item.done ? "checkmark.square.fill" : "square")
                                .font(.system(size: 16))
                                .foregroundStyle(item.done ? .green : .gray)
                                .onTapGesture { item.done.toggle() }

                            Circle()
                                .fill(priorityColor(item.priority))
                                .frame(width: 10, height: 10)

                            VStack(alignment: .leading, spacing: 3) {
                                HStack(spacing: 8) {
                                    Text(item.title)
                                        .font(.body)
                                        .strikethrough(item.done)

                                    if item.priority == 1 {
                                        Text("URGENT")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundStyle(Color(red: 1.0, green: 0.88, blue: 0.2))
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color.white)
                                            .clipShape(Capsule())
                                    }
                                }

                                Text("\(item.course) · Due \(item.due)")
                                    .font(.system(size: 11))
                                    .foregroundStyle(Color(white: 0.75))

                                Text("Instructions: Make sure to read textbook pages 84-92 thoroughly, answer every review question in your notebook, and cite all sources.")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                    .frame(height: 10)
                                    .clipped()
                            }

                            Spacer()

                            Button {
                                helpRequestedID = item.id
                            } label: {
                                Image(systemName: helpRequestedID == item.id ? "mic.circle.fill" : "mic.circle")
                                    .font(.system(size: 20))
                                    .foregroundStyle(.blue)
                            }

                            ZStack {
                                RoundedRectangle(cornerRadius: 2)
                                    .stroke(Color.red.opacity(0.6), lineWidth: 1)
                                    .background(Color.red.opacity(0.08))
                                Image(systemName: "xmark")
                                    .font(.system(size: 7, weight: .bold))
                                    .foregroundStyle(.red)
                            }
                            .frame(width: 12, height: 12)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                assignments.removeAll { $0.id == item.id }
                            }
                        }

                        if helpRequestedID == item.id {
                            Text("Say what you need help with — a teacher will follow up.")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .background(cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
        }
    }

    // MARK: - Add Assignment Modal

    var addAssignmentModal: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Assignment Title")
                        .font(.subheadline.bold())
                    TextField("e.g. Read chapter 5", text: $newTitle)
                        .textFieldStyle(.roundedBorder)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Course Name")
                        .font(.subheadline.bold())
                    TextField("e.g. Biology", text: $newCourse)
                        .textFieldStyle(.roundedBorder)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Add a Note")
                        .font(.subheadline.bold())
                    Button {
                        voiceNoteCaptured = true
                    } label: {
                        HStack {
                            Image(systemName: voiceNoteCaptured ? "checkmark.circle.fill" : "mic.fill")
                            Text(voiceNoteCaptured ? "Voice note attached" : "Hold and say your note")
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                    }
                    .buttonStyle(.bordered)
                }

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(.red)
                }

                Spacer()

                Button {
                    addAssignment()
                } label: {
                    Text("Add Assignment")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle("New Assignment")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        errorMessage = ""
                        showingAddModal = false
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    // MARK: - Tab 2: Study Timer

    var timerTab: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Text("Focus Session")
                            .font(.subheadline.bold())
                            .foregroundStyle(.secondary)

                        Text(timeString)
                            .font(.system(size: 64, weight: .bold, design: .monospaced))

                        Circle()
                            .fill(timerRunning ? Color.green : Color.orange)
                            .frame(width: 72, height: 72)
                            .overlay {
                                Image(systemName: timerRunning ? "pause.fill" : "play.fill")
                                    .font(.title)
                                    .foregroundStyle(.white)
                            }
                            .onTapGesture(count: 2) {
                                toggleTimer()
                            }

                        Text("Double-tap to start or pause")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        if handsFreeMode {
                            VStack(spacing: 6) {
                                Image(systemName: "mic.fill")
                                    .font(.title)
                                    .foregroundStyle(.blue)
                                Text("Say \"Start\" or \"Reset\" to control the timer")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.top, 4)
                        } else {
                            VStack(spacing: 6) {
                                Text("Quick Controls (Green = Start, Red = Reset):")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)

                                HStack(spacing: 24) {
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 44, height: 44)
                                        .onTapGesture {
                                            startTimer()
                                        }

                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 44, height: 44)
                                        .onTapGesture {
                                            resetTimer()
                                        }
                                }
                            }
                            .padding(.top, 4)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
                    .background(cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Session Settings")
                            .font(.headline)

                        VStack(spacing: 12) {
                            Picker("Interval Length", selection: $sessionDuration) {
                                Text("1 minute").tag(60)
                                Text("5 minutes").tag(5 * 60)
                                Text("15 minutes").tag(15 * 60)
                                Text("25 minutes").tag(25 * 60)
                            }
                            .onChange(of: sessionDuration) { _, newDuration in
                                applySessionDuration(newDuration)
                            }
                            Divider()
                            HStack {
                                Text("Sound Chime")
                                Spacer()

                                Button {
                                    playTimerEndSound()
                                } label: {
                                    Image(systemName: "speaker.wave.2.fill")
                                }

                                HStack(spacing: 12) {
                                    Circle()
                                        .fill(Color.green)
                                    .frame(width: 36, height: 28)
                                    .opacity(isChimeEnabled ? 1 : 0.3)
                                    .onTapGesture {
                                        isChimeEnabled = true
                                    }

                                    Circle()
                                        .fill(Color.red)
                                    .frame(width: 36, height: 28)
                                    .opacity(isChimeEnabled ? 0.3 : 1)
                                    .onTapGesture {
                                        isChimeEnabled = false
                                    }
                                }
                            }
                            Divider()
                            HStack {
                                Text("Hands-Free Mode")
                                Spacer()
                                Toggle("", isOn: $handsFreeMode)
                                    .labelsHidden()
                            }
                        }
                        .padding()
                        .background(cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding()
            }
            .navigationTitle("Study Timer")
        }
    }

    // MARK: - Tab 3: Audio Notes

    var audioNotesTab: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Classroom Recordings")
                        .font(.headline)

                    HStack(spacing: 16) {
                        Button {
                            audioPlayer.togglePlay()
                        } label: {
                            Image(systemName: audioPlayer.isPlaying ? "stop.circle.fill" : "play.circle.fill")
                                .font(.system(size: 48))
                                .foregroundStyle(.blue)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Talk by Steven Jobs — IDCA 1983")
                                .font(.headline)
                            Text("International Design Conference · 1983")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(audioPlayer.isPlaying ? "Playing recording…" : "Tap to listen")
                                .font(.caption2)
                                .foregroundStyle(audioPlayer.isPlaying ? .blue : .secondary)
                        }

                        Spacer()

                        Button {
                            captionsEnabled.toggle()
                        } label: {
                            Text("CC")
                                .font(.caption.bold())
                                .padding(6)
                                .background(captionsEnabled ? Color.blue : Color.gray.opacity(0.2))
                                .foregroundStyle(captionsEnabled ? .white : .primary)
                                .clipShape(Capsule())
                        }
                    }
                    .padding()
                    .background(cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Ask About This Recording")
                            .font(.subheadline.bold())
                            .foregroundStyle(.secondary)

                        Button {
                            questionAsked = true
                        } label: {
                            HStack {
                                Image(systemName: "mic.fill")
                                Text(questionAsked ? "Question sent" : "Tap and say your question")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding()
                    .background(cardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Upcoming Notes")
                            .font(.subheadline.bold())
                            .foregroundStyle(.secondary)

                        HStack {
                            Image(systemName: "waveform.badge.mic")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Bio Lab Safety Briefing")
                                    .font(.subheadline.bold())
                                Text("Scheduled for Friday")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                        .padding()
                        .background(cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding()
            }
            .navigationTitle("Audio Notes")
        }
    }

    // MARK: - Helpers

    var timeString: String {
        String(format: "%02d:%02d", secondsLeft / 60, secondsLeft % 60)
    }

    func priorityColor(_ priority: Int) -> Color {
        switch priority {
        case 1: return .red
        case 2: return .yellow
        default: return .green
        }
    }

    func addAssignment() {
        let trimmed = newTitle.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            errorMessage = "Error 0x1A"
            newTitle = ""
            newCourse = ""
            return
        }
        assignments.append(Assignment(title: trimmed, course: newCourse, due: "Not set", priority: 2))
        newTitle = ""
        newCourse = ""
        errorMessage = ""
        showingAddModal = false
    }

    func tick() {
        guard timerRunning else { return }
        if secondsLeft > 0 {
            secondsLeft -= 1
        }
        if secondsLeft == 0 {
            timerRunning = false
            if isChimeEnabled {
                playTimerEndSound()
            }
            secondsLeft = sessionDuration
        }
    }

    func toggleTimer() {
        if timerRunning {
            timerRunning = false
        } else {
            startTimer()
        }
    }

    func startTimer() {
        if secondsLeft == 0 {
            secondsLeft = sessionDuration
        }
        timerRunning = true
    }

    func resetTimer() {
        timerRunning = false
        secondsLeft = sessionDuration
    }

    func applySessionDuration(_ duration: Int) {
        timerRunning = false
        secondsLeft = duration
    }

    func playTimerEndSound() {
        #if canImport(AppKit) && !targetEnvironment(macCatalyst)
        NSSound.beep()
        #elseif canImport(AudioToolbox)
        AudioServicesPlaySystemSound(1005)
        #endif
    }

    func playAnnouncementChime() {
        #if canImport(AppKit) && !targetEnvironment(macCatalyst)
        NSSound.beep()
        #elseif canImport(AudioToolbox)
        AudioServicesPlaySystemSound(1007)
        #endif
    }
}

#Preview {
    ContentView()
}
