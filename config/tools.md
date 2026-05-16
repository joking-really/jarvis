# Jarvis Tools Reference

## Core Tools

### Terminal
- Shell command execution on Ubuntu Linux
- Background process support
- PTY mode for interactive tools
- Timeout support (default 180s)

### File Operations
- `read_file`: Read text files with pagination
- `write_file`: Create/overwrite files
- `search_files`: Ripgrep-backed content/file search
- `patch`: Targeted find-and-replace edits

### Code Execution
- `execute_code`: Run Python scripts with tool access
- 5-minute timeout, 50KB stdout cap
- Can call Hermes tools programmatically

### Web
- `web_search`: Search the internet
- `x_search`: Search X/Twitter posts

## GitHub Tools
- `gh` CLI: Full repository management
- Authenticated as joking-really
- Can create, clone, push, manage repos

## Media Tools
- `image_generate`: Create images from prompts
- `video_analyze`: Analyze video content
- `video_generate`: Generate videos (text or image-to-video)
- `text_to_speech`: Convert text to audio

## Agent Tools
- `delegate_task`: Spawn sub-agents for parallel work
- `cronjob`: Schedule recurring tasks
- `memory`: Save/retrieve persistent memory

## Communication
- `send_message`: Send messages to connected platforms
- `clarify`: Ask user questions when needed
- `todo`: Manage task lists

## Full Tool List
browser, computer_use, cronjob, discord, discord_admin, feishu_doc, feishu_drive, file, homeassistant, image_gen, kanban, search, session_search, skills, spotify, terminal, todo, tts, video, video_gen, vision, web, x_search, yuanbao
