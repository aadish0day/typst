// === Maze Solver: CA Assignment ===
// Typst Document for Course Assignment
// Author: Aadish das | UID: 24BIT010 | Roll No: 10

#set document(
  title: "Maze Solver — CA Assignment: AI Pathfinding Visualizer",
  author: "Aadish das",
  date: auto,
)

#set page(
  paper: "a4",
  margin: (left: 1.5in, right: 1in, top: 1in, bottom: 1in),
  numbering: "1",
  number-align: center,
  background: place(
    center + horizon,
    rect(
      width: 100% - 1.5cm,
      height: 100% - 1.5cm,
      stroke: 1pt + black,
    )
  ),
)

#set text(
  font: ("Liberation Serif", "DejaVu Serif"),
  size: 11pt,
  lang: "en",
  hyphenate: true,
)

#set par(justify: true, leading: 0.65em, first-line-indent: 0pt)
#set heading(numbering: "1.1")

#show table.cell: set text(size: 9.5pt)
#show table.cell.where(y: 0): set text(size: 9.5pt, weight: "bold")
#show table.cell.where(y: 0): set align(center + horizon)

#show raw.where(block: true): it => block(
  fill: rgb("F8F9FA"),
  stroke: 0.5pt + rgb("D0D5DD"),
  inset: (x: 9pt, y: 7pt),
  radius: 3pt,
  width: 100%,
  text(
    font: ("JetBrains Mono", "DejaVu Sans Mono", "Liberation Mono"),
    size: 8pt,
    it
  )
)

#show raw.where(block: false): it => text(
  font: ("JetBrains Mono", "DejaVu Sans Mono", "Liberation Mono"),
  size: 9pt,
  fill: rgb("0D7377"),
  weight: "medium",
  it
)

#let styled-table(columns: (), headers: (), ..rows) = table(
  columns: columns,
  stroke: (x, y) => if y == 0 { (top: 1.2pt + rgb("0D7377"), bottom: 1.2pt + rgb("0D7377")) } else { 0.4pt + luma(200) },
  fill: (x, y) => if y == 0 { rgb("E8F4F4") } else if calc.even(y) { rgb("FAFCFC") } else { none },
  inset: (x: 6pt, y: 5pt),
  table.header(repeat: true, ..headers.map(h => [#text(size: 9.5pt, weight: "bold", fill: rgb("0D7377"))[#h]])),
  ..rows.pos().map(cell => text(size: 9pt)[#cell])
)

#let algo-box(title, body, color) = block(
  fill: color.lighten(95%),
  stroke: (left: 3pt + color, rest: 0.3pt + color.lighten(50%)),
  inset: (x: 12pt, y: 10pt),
  radius: (right: 4pt),
  width: 100%,
  [
    #text(weight: "bold", size: 11pt, fill: color)[#title]\
    #v(4pt)
    #text(size: 9.5pt)[#body]
  ]
)

// ==========================================
// TITLE & METADATA HEADER
// ==========================================

#align(center)[
  #block(
    fill: rgb("F0F7F7"),
    stroke: 1pt + rgb("0D7377"),
    inset: (x: 16pt, y: 14pt),
    radius: 6pt,
    width: 100%,
    [
      #text(size: 18pt, weight: "bold", fill: rgb("0D7377"))[Maze Solver]\
      #v(2pt)
      #text(size: 13pt, weight: "bold")[Interactive Pathfinding Algorithm Visualizer]\
      #v(4pt)
      #text(size: 11pt, style: "italic")[A Python/Pygame Application for Comparing BFS, DFS, and A\* Search Algorithms]\
      #v(8pt)
      #line(length: 60%, stroke: 0.6pt + rgb("0D7377"))
      #v(6pt)
      #grid(
        columns: (1fr, 1fr),
        align: (left, right),
        [
          #text(size: 9.5pt)[*Subject:* Computer Algorithms / AI]\
          #text(size: 9.5pt)[*Assessment:* CA Assignment]\
          #text(size: 9.5pt)[*Language:* Python 3.14 / Pygame-CE 2.5.8]
        ],
        [
          #text(size: 9.5pt)[*Student Name:* Aadish das]\
          #text(size: 9.5pt)[*UID:* 24BIT010 | *Roll No:* 10]\
          #text(size: 9.5pt)[*Repository:* `maze-solver`]
        ]
      )
    ]
  )
]

#v(8pt)

#styled-table(
  columns: (1.5fr, 3.5fr),
  headers: ("Project Metadata", "Technical Specification"),
  "Project Name", "Maze Solver — Interactive Pathfinding Visualizer",
  "Language & Runtime", "Python 3.14.7",
  "GUI Framework", "Pygame Community Edition (pygame-ce) 2.5.8",
  "Algorithms Implemented", "BFS (Breadth-First Search), DFS (Depth-First Search), A\* Search",
  "Maze Generation", "Iterative Recursive Backtracking (DFS-based perfect maze generator)",
  "Source File Count", "5 Python modules (~862 lines of code)",
  "Course Code / Title", "CA Assignment — Algorithms / Artificial Intelligence",
  "Submission Date", "September 2026"
)

#pagebreak()

// ==========================================
// TABLE OF CONTENTS
// ==========================================

#outline(
  title: [Table of Contents],
  indent: 1.5em,
  depth: 2,
)

#pagebreak()

// ==========================================
// SECTION 1: ABSTRACT
// ==========================================

= Abstract

*Maze Solver* is an interactive maze generator and pathfinding visualizer built with Python 3.14 and Pygame Community Edition. It runs three classic graph search algorithms: *BFS (breadth-first search)*, *DFS (depth-first search)*, and *A\* search*. Animated real-time output makes it easy to compare exploration patterns, efficiency, and path optimality side by side.

Mazes are built with *iterative recursive backtracking*. Every algorithm runs as a Python generator that yields its internal state at each step, so the program can animate smoothly at any speed between 1 and 128 steps per frame. The user watches the frontier expand, the visited region grow, and the final path appear.

The program also supports interactive editing (wall toggling, moving the start and goal), a compare mode that runs all three algorithms on the same maze at once, and live statistics for nodes explored and path length.

== Contributions

1. All algorithms are written as Python generators that yield `(visited, frontier, path)` tuples, so the visualization steps forward without blocking.
2. BFS finds the shortest path with a FIFO queue, DFS explores one branch at a time with a LIFO stack, and A\* stays optimal by guiding the search with the Manhattan heuristic.
3. A split-pane compare mode runs all three algorithms on the same maze at once, which maps exploration differences directly.
4. Users can edit walls, move the start and goal, and re-solve to see how maze topology changes each algorithm's performance.

// ==========================================
// SECTION 2: PROBLEM STATEMENT
// ==========================================

= Problem statement

Textbooks explain how BFS, DFS, and A\* work, but seeing why they behave differently usually takes a visual, interactive demonstration. Exploration patterns, path optimality, and computational cost are much easier to grasp when the search is on screen.

== Core problems

+ BFS, DFS, and A\* work on graph structures that are hard to follow from pseudocode alone. Students need to watch the frontier expand, see which cells each algorithm visits first, and compare the resulting paths.

+ BFS guarantees the shortest path but visits many cells to get it. DFS uses little memory, yet the path can be suboptimal. A\* balances both with a heuristic, and the trade-off is easiest to see when the two sit side by side.

+ Maze shape changes the comparison. Dense mazes with many dead ends hurt DFS more than BFS or A\*, while open mazes with long corridors shift the picture again.

+ Most existing visualizers are static, run a single algorithm, or live in a browser. A desktop tool with real-time editing and simultaneous multi-algorithm comparison suits classroom demonstrations better.

== Objectives

- Implement BFS, DFS, and A\* as composable generator functions.
- Generate perfect mazes via recursive backtracking with animated rendering.
- Provide side-by-side comparison of all three algorithms.
- Allow interactive maze editing (wall toggling, start/goal repositioning).
- Display live statistics: nodes explored, path length, and completion status.
- Achieve smooth 60 FPS animation at configurable speeds.

// ==========================================
// SECTION 3: SYSTEM ARCHITECTURE
// ==========================================

= System architecture

== Module overview

The program is split into five Python modules:

#styled-table(
  columns: (1.2fr, 0.6fr, 3.2fr),
  headers: ("Module", "Lines", "Responsibility"),
  "`main.py`", "406", "Application entry point. Contains the `Game` class owning the Pygame window, main loop, finite state machine, event handling, and UI orchestration.",
  "`maze.py`", "97", "Domain model. `Maze` class (2D boolean grid) and `generate_maze_animated()` generator for recursive backtracking maze carving.",
  "`solver.py`", "119", "Algorithm module. Three generator functions: `bfs_solve`, `dfs_solve`, `astar_solve`, plus shared helpers (`manhattan`, `reconstruct`).",
  "`ui.py`", "142", "Widget library. Four reusable Pygame widgets: `Button`, `RadioGroup`, `Slider`, `CheckBox` — each handling its own events and rendering.",
  "`visualizer.py`", "98", "Rendering module. Grid layout computation, mouse-to-cell mapping, maze panel drawing, and color legend rendering.",
)

== Application state machine

The `Game` class implements a four-state finite state machine:

#algo-box(
  [State Transition Diagram],
  [
    ```text
    "generating" --> "interactive" --> "solving" --> "solved"
          ^                ^              |              |
          |                |              v              |
          +---- "stop" ----+              |              |
          +------------- "stop" ---------+              |
          +------------- "stop" -----------------------+
    ```
    - *"generating"*: maze carving is animating and the generator yields one cell per step.
    - *"interactive"*: the maze is complete and the user can edit walls, move start and goal, or trigger a solve.
    - *"solving"*: one or more solver generators are running and each yields `(visited, frontier, path)`.
    - *"solved"*: all solvers have finished and the stats are shown.
  ],
  rgb("2B579A")
)

== Dependency graph

```text
main.py
  ├── maze.py       (Maze, generate_maze_animated)
  ├── solver.py     (ALGORITHMS dict)
  │     └── maze.py (DIRS constants)
  ├── ui.py         (Button, RadioGroup, Slider, CheckBox)
  └── visualizer.py (draw_maze, draw_legend, cell_at, grid_layout)
```

The only external dependency is `pygame-ce` (Pygame Community Edition). Everything else comes from the Python standard library: `random`, `sys`, `heapq`, `itertools`, `collections.deque`.

#pagebreak()

// ==========================================
// SECTION 4: ALGORITHM DESIGN
// ==========================================

= Algorithm design and implementation

== Maze generation with recursive backtracking

The generator makes *perfect mazes*, where exactly one path connects any two open cells and no loops exist. It works on a grid of "node" cells at even rows and even columns, carving passages by stepping 2 cells at a time.

#algo-box(
  [Algorithm: Maze Generation (Recursive Backtracking)],
  [
    ```python
    def generate_maze_animated(rows, cols, maze=None, rng=None):
        """Carve a perfect maze one step at a time (generator)."""
        stack = [start]
        visited[start[0]][start[1]] = True
        maze.carve(*start)
        yield start

        while stack:
            r, c = stack[-1]
            # Look at candidates 2 steps away in 4 directions
            candidates = [(nr, nc, wr, wc) for (nr, nc, wr, wc)
                          if in_bounds and not visited]

            if candidates:
                nr, nc, wr, wc = rng.choice(candidates)
                maze.carve(r + wr, c + wc)  # carve intermediate wall
                maze.carve(nr, nc)           # carve target node
                stack.append((nr, nc))
                yield (nr, nc)
            else:
                stack.pop()  # backtrack
    ```
  ],
  rgb("6B4C9A")
)

*Key properties:*
- Uses an explicit stack, so it never hits Python's recursion limit.
- Picks a random unvisited neighbor at each step, so two runs rarely produce the same maze.
- Yields `(row, col)` for each carved cell, which lets the program animate the carving.
- DFS-based carving guarantees full connectivity with no loops.

== BFS (breadth-first search)

BFS explores the maze level by level, using a *FIFO queue* (`collections.deque`). It guarantees the *shortest path* in an unweighted grid.

#algo-box(
  [Algorithm: BFS],
  [
    ```python
    def bfs_solve(maze, start, end):
        """Queue (FIFO) — guarantees shortest path."""
        visited = {start}
        came_from = {start: None}
        queue = deque([start])
        frontier = {start}

        while queue:
            cur = queue.popleft()         # FIFO: oldest first
            frontier.discard(cur)
            if cur == end:
                yield visited, frontier, reconstruct(came_from, start, end)
                return
            for nb in maze.get_open_neighbors(*cur):
                if nb not in visited:
                    visited.add(nb)
                    came_from[nb] = cur
                    queue.append(nb)
                    frontier.add(nb)
            yield visited, frontier, None
    ```
  ],
  rgb("2196F3")
)

*Characteristics:*
- *Data structure:* `deque` (FIFO queue) + `set` for visited + `dict` for `came_from`.
- *Optimality:* Guarantees shortest path in unweighted graphs.
- *Completeness:* Always finds a path if one exists.
- *Exploration pattern:* Uniform outward expansion; it explores all cells at distance *d* before distance *d+1*.
- *Time complexity:* $O(V + E)$ where $V$ = cells, $E$ = passages.
- *Space complexity:* $O(V)$ for the queue and visited set.

== DFS (depth-first search)

DFS explores one branch as deeply as possible before backtracking, using a *LIFO stack* (Python list). It does *not* guarantee the shortest path.

#algo-box(
  [Algorithm: DFS],
  [
    ```python
    def dfs_solve(maze, start, end):
        """Stack (LIFO) — explores one branch deep first."""
        order = DIRS[::-1]  # reversed order for visual contrast
        visited = {start}
        came_from = {start: None}
        stack = [start]

        while stack:
            cur = stack.pop()             # LIFO: newest first
            frontier.discard(cur)
            if cur == end:
                yield visited, frontier, reconstruct(came_from, start, end)
                return
            for nb in maze.get_open_neighbors(*cur, order=order):
                if nb not in visited:
                    visited.add(nb)
                    came_from[nb] = cur
                    stack.append(nb)
                    frontier.add(nb)
            yield visited, frontier, None
    ```
  ],
  rgb("FF9800")
)

*Characteristics:*
- *Data structure:* Python `list` (LIFO stack) + `set` for visited + `dict` for `came_from`.
- *Optimality:* Does not guarantee the shortest path and may find a much longer route.
- *Completeness:* Finds a path if one exists (in finite graphs).
- *Exploration pattern:* Deep and narrow; it dives down one branch before backtracking.
- *Neighbor order:* Reversed (`DIRS[::-1]`) to create visual contrast with BFS.
- *Space complexity:* $O(V)$ worst case, but typically less than BFS due to stack depth vs. queue breadth.

== A\* search

A\* adds Dijkstra-style costing to the BFS idea of optimality. It keeps a *priority queue* (min-heap) and a *heuristic function* that estimates the remaining distance to the goal.

#algo-box(
  [Algorithm: A\* search],
  [
    ```python
    def astar_solve(maze, start, end):
        """Priority queue (min-heap) with Manhattan heuristic."""
        visited = set()
        came_from = {start: None}
        g_score = {start: 0}
        counter = itertools.count()  # tie-breaker for heap
        heap = [(manhattan(start, end), 0, next(counter), start)]

        while heap:
            _, g, _, cur = heapq.heappop(heap)
            if cur in visited:
                continue
            visited.add(cur)
            if cur == end:
                yield visited, frontier, reconstruct(came_from, start, end)
                return
            for nb in maze.get_open_neighbors(*cur):
                ng = g + 1
                if ng < g_score.get(nb, float("inf")):
                    came_from[nb] = cur
                    g_score[nb] = ng
                    f = ng + manhattan(nb, end)  # f = g + h
                    heapq.heappush(heap, (f, ng, next(counter), nb))
            yield visited, frontier, None
    ```
  ],
  rgb("4CAF50")
)

*Heuristic Function:*
```python
def manhattan(a, b):
    """Admissible heuristic for 4-directional grid movement."""
    return abs(a[0] - b[0]) + abs(a[1] - b[1])
```

*Characteristics:*
- *Data structure:* `heapq` min-heap (priority queue) + `dict` for `g_score` + `dict` for `came_from`.
- *Priority:* $f(n) = g(n) + h(n)$ where $g$ = cost from start, $h$ = Manhattan distance to goal.
- *Optimality:* Finds shortest path (like BFS) when heuristic is admissible and consistent.
- *Efficiency:* Typically explores fewer cells than BFS due to heuristic guidance toward the goal.
- *Tie-breaking:* `itertools.count()` counter prevents heap comparison of non-comparable cell tuples.
- *Heuristic admissibility:* Manhattan distance never overestimates the true shortest path in a 4-directional grid.

== Path reconstruction

All three algorithms share a common path reconstruction function:

```python
def reconstruct(came_from, start, end):
    """Walk back through came_from links to rebuild the solution path."""
    if end not in came_from:
        return []
    path = []
    cur = end
    while cur != start:
        path.append(cur)
        cur = came_from[cur]
    path.append(start)
    path.reverse()
    return path
```

This traces the `came_from` dictionary backward from goal to start, then reverses to produce the forward path.

#pagebreak()

// ==========================================
// SECTION 5: ALGORITHM COMPARISON
// ==========================================

= Algorithm comparison and analysis

== Theoretical comparison

#styled-table(
  columns: (1fr, 1.5fr, 1.5fr, 1.5fr),
  headers: ("Property", "BFS", "DFS", "A\*"),
  "Data Structure", "Queue (FIFO)", "Stack (LIFO)", "Priority Queue (Min-Heap)",
  "Optimality", "Shortest path guaranteed", "No guarantee", "Shortest path (admissible h)",
  "Completeness", "Yes (finite graphs)", "Yes (finite graphs)", "Yes (finite graphs)",
  "Time Complexity", "$O(V + E)$", "$O(V + E)$", "$O(V + E)$ worst case",
  "Space Complexity", "$O(V)$ — large queue", "$O(V)$ — stack depth", "$O(V)$ — heap + g\_score",
  "Exploration Pattern", "Uniform outward expansion", "Deep, narrow branches", "Heuristic-guided toward goal",
  "Typical Cells Explored", "Many (explores uniformly)", "Varies (path-dependent)", "Fewest (goal-directed)",
  "Best Use Case", "Shortest path, unweighted graphs", "Memory-constrained, maze traversal", "Optimal path with heuristic info",
)

== Visual comparison

The *Compare Mode* splits the window into three panes and runs one algorithm in each on the same maze. The differences show up directly:

+ BFS spreads out in a uniform wave, DFS drills down narrow corridors, and A\* aims straight at the goal.
+ BFS tends to visit the most cells, A\* the fewest, and DFS varies.
+ BFS and A\* return a shortest path; DFS may take a longer route.
+ A\* usually finishes first, then BFS, then DFS, though the maze shape can reorder that.

== Speed control

The speed slider maps values 1 to 8 to `2^(value-1)` steps per frame:

#styled-table(
  columns: (1fr, 1fr, 1.5fr),
  headers: ("Slider Value", "Steps/Frame", "Effective Rate (60 FPS)"),
  "1", "1", "60 steps/sec",
  "2", "2", "120 steps/sec",
  "3", "4", "240 steps/sec",
  "4", "8", "480 steps/sec",
  "5 (default)", "16", "960 steps/sec",
  "6", "32", "1,920 steps/sec",
  "7", "64", "3,840 steps/sec",
  "8", "128", "7,680 steps/sec",
)

#pagebreak()

// ==========================================
// SECTION 6: CODE WALKTHROUGH
// ==========================================

= Detailed code walkthrough

== `maze.py`: maze data structure and generation

The `Maze` class represents the grid as a 2D boolean array where `True` = wall and `False` = open passage.

```python
class Maze:
    """Rectangular grid of wall / open cells."""

    def __init__(self, rows, cols):
        self.rows = rows
        self.cols = cols
        self.walls = [[True] * cols for _ in range(rows)]

    def in_bounds(self, r, c):
        return 0 <= r < self.rows and 0 <= c < self.cols

    def is_open(self, r, c):
        return self.in_bounds(r, c) and not self.walls[r][c]

    def carve(self, r, c):
        self.walls[r][c] = False

    def toggle(self, r, c):
        self.walls[r][c] = not self.walls[r][c]

    def get_open_neighbors(self, r, c, order=None):
        """Return the list of open neighbours of (r, c)."""
        dirs = order if order is not None else DIRS
        result = []
        for dr, dc in dirs:
            nr, nc = r + dr, c + dc
            if self.is_open(nr, nc):
                result.append((nr, nc))
        return result
```

*Design choices:*
- Grid size defaults to 21×29; odd dimensions keep wall and passage cells alternating.
- `get_open_neighbors()` takes an `order` parameter so DFS can reverse its direction.
- `toggle()` lets the user edit walls from the UI.

== `solver.py`: the three solvers

The solver module exports an `ALGORITHMS` dictionary mapping names to generator functions:

```python
ALGORITHMS = {
    "BFS": bfs_solve,
    "DFS": dfs_solve,
    "A*": astar_solve,
}
```

Each solver is a *generator* that `yield`s `(visited_set, frontier_set, path_list_or_None)` at every step. That is what makes the animation possible. The `Game` class calls `next()` on these generators a set number of times per frame.

== `ui.py`: reusable UI widgets

Four widget classes, all following the same interface:

```python
class Button:
    """Clickable button with label and action callback."""
    def handle_event(self, event) -> bool: ...
    def draw(self, surface, font): ...

class RadioGroup:
    """Set of radio-button options with single selection."""
    def handle_event(self, event) -> bool: ...
    def draw(self, surface, font): ...

class Slider:
    """Draggable value slider with min/max range."""
    def handle_event(self, event) -> bool: ...
    def draw(self, surface, font): ...

class CheckBox:
    """Toggle checkbox with label."""
    def handle_event(self, event) -> bool: ...
    def draw(self, surface, font): ...
```

Each widget encapsulates its own event handling and drawing logic, keeping `main.py` free of low-level Pygame rendering details.

== `visualizer.py`: rendering

The visualizer does two layout computations:

*Grid layout computation:*
```python
def grid_layout(grid_rect, maze):
    """Compute (origin_x, origin_y, cell_size) to center the grid in a panel."""
    inner = grid_rect.inflate(-16, -16)
    cell = max(1, min(inner.width // maze.cols, inner.height // maze.rows))
    gw, gh = cell * maze.cols, cell * maze.rows
    ox = inner.x + (inner.width - gw) // 2
    oy = inner.y + (inner.height - gh) // 2
    return ox, oy, cell
```

*Mouse-to-cell mapping:*
```python
def cell_at(pos, panel_rect, maze):
    """Map a mouse position to a maze cell, or None."""
    grid_rect = pygame.Rect(panel_rect.x, panel_rect.y + HEADER, ...)
    ox, oy, cell = grid_layout(grid_rect, maze)
    c = (pos[0] - ox) // cell
    r = (pos[1] - oy) // cell
    if maze.in_bounds(r, c):
        return r, c
    return None
```

Both functions share the same layout math, so drawing and mouse hit-testing stay aligned to the pixel.

== `main.py`: application core

The `Game` class (406 lines) orchestrates everything:

At startup the game creates the Pygame window (1280×800), loads the fonts, builds the UI widgets, and generates the first maze.

*Main loop:*
```python
def run(self):
    while True:
        dt = self.clock.tick(FPS) / 1000.0
        for event in pygame.event.get():
            # Route events to widgets and maze editor
        if self.state == "generating":
            self._advance_generation(self.steps_per_frame)
        elif self.state == "solving":
            self._step_solvers(self.steps_per_frame)
        self.screen.fill(WHITE)
        self._draw_panels()
        self._draw_sidebar()
        pygame.display.flip()
```

*Solver stepping:*
```python
def _step_solvers(self, steps):
    for name in list(self.solvers):
        gen = self.solvers[name]
        for _ in range(steps):
            try:
                visited, frontier, path = next(gen)
            except StopIteration:
                done = True
                break
            self.live[name] = (visited, frontier, path)
```

Each frame advances every active solver by `steps` generator yields, which is what animates the search.

#pagebreak()

// ==========================================
// SECTION 7: INTERACTIVE FEATURES
// ==========================================

= Interactive features

== Maze editing tools

Three editing tools are available via the sidebar radio group:

#styled-table(
  columns: (1fr, 2fr, 2fr),
  headers: ("Tool", "Behavior", "Constraints"),
  "Wall", "Click or drag to toggle wall/passage state", "Cannot wall up Start or Goal cells",
  "Start", "Click to reposition the start cell", "Must be placed on an open (non-wall) cell",
  "Goal", "Click to reposition the goal cell", "Must be placed on an open (non-wall) cell",
)

With the Wall tool active, holding the mouse and dragging paints several cells without lifting the cursor.

== Keyboard shortcuts

#styled-table(
  columns: (1.5fr, 3.5fr),
  headers: ("Key", "Action"),
  "`R`", "Generate a new random maze",
  "`Enter` / `Space`", "Solve with the selected algorithm (or all three in compare mode)",
  "`Esc` / `C`", "Stop / clear the current search",
  "`1`", "Select BFS (single solver mode)",
  "`2`", "Select DFS (single solver mode)",
  "`3`", "Select A\* (single solver mode)",
)

== Compare mode

Choosing "Compare all 3" splits the maze area into three equal panes, each labeled with its algorithm name. All three solvers run at once on the same maze, and the sidebar keeps independent stats for each. The stats panel names the algorithm that explored the fewest cells.

== Live statistics

During and after solving, the sidebar displays per-algorithm statistics:

- *nodes:* Number of cells explored so far.
- *path:* Length of the solution path (0 if goal not yet reached).
- *status:* "searching...", "found", or "no path".

After all solvers complete, a hint line indicates which algorithm was most efficient.

#pagebreak()

// ==========================================
// SECTION 8: COLOR SCHEME & UI DESIGN
// ==========================================

= Color scheme and visual design

The application uses a dark theme optimized for contrast and readability:

#styled-table(
  columns: (1.5fr, 1.5fr, 1fr, 2fr),
  headers: ("Element", "RGB Value", "Hex", "Description"),
  "Background", "`(26, 28, 36)`", "`#1A1C24`", "Near-black blue — window background",
  "Wall", "`(58, 63, 78)`", "`#3A3F4E`", "Dark gray-blue — wall cells",
  "Open Passage", "`(216, 218, 226)`", "`#D8DAE2`", "Light gray — open cells",
  "Visited", "`(92, 150, 255)`", "`#5C96FF`", "Blue — cells explored by the algorithm",
  "Frontier", "`(70, 215, 240)`", "`#46D7F0`", "Cyan — cells in the queue/stack/heap",
  "Solution Path", "`(255, 208, 74)`", "`#FFD04A`", "Gold — final shortest/found path",
  "Start", "`(88, 214, 122)`", "`#58D67A`", "Green — start cell",
  "Goal", "`(245, 96, 96)`", "`#F56060`", "Red — goal cell",
  "Carving Cursor", "`(255, 130, 110)`", "`#FF826E`", "Salmon — active cell during generation",
)

#pagebreak()

// ==========================================
// SECTION 9: OUTPUT SCREENSHOTS
// ==========================================

= Output screenshots

The screenshots below were captured from the running program.

== Single solver mode: live search

#figure(
  image("attachments/single_mode_live.png", width: 100%),
  caption: [
    *BFS running on a 21×29 maze in single-solver mode.* Blue cells show visited nodes, cyan shows the frontier, and the sidebar reports live node/path statistics. The start (green) and goal (red) cells are visible in the top-left and bottom-right corners.
  ],
) <fig-single-live>

In single-solver mode, one algorithm runs at a time on the full maze area. The sidebar holds every control: maze regeneration, solve and stop actions, edit tools, algorithm choice, speed slider, and toggleable overlays.

== Compare mode: all three algorithms solved

#figure(
  image("attachments/compare_mode_solved.png", width: 100%),
  caption: [
    *Compare mode after BFS, DFS, and A\* have all finished.* Each pane shows the same maze solved by one algorithm. Gold cells mark the solution path; the stats panel lists nodes explored and path length per algorithm and names the most efficient one.
  ],
) <fig-compare-solved>

In compare mode, all three algorithms run at once on the same maze, so the differences are visible directly:
- BFS spreads out in a uniform wave, DFS drives down corridors, and A\* aims at the goal.
- BFS and A\* produce the same shortest path; DFS often finds a longer one after exploring dead ends.
- The number of blue visited cells shows how much work each algorithm did.

#pagebreak()

// ==========================================
// SECTION 10: TECHNICAL HIGHLIGHTS
// ==========================================

= Technical highlights

== The generator pattern

The central design choice is that *every algorithm is a Python generator*. This gives four benefits:

1. The main loop calls `next()` on each generator a set number of times per frame, so animation never blocks the UI.
2. Each `yield` returns the full search state `(visited, frontier, path)`, so nothing needs to be tracked outside the generator.
3. `Game._step_solvers()` handles BFS, DFS, and A\* the same way; only the generator function changes.
4. `StopIteration` marks the end of a search, so no separate completion signal is needed.

== Heuristic design for A\*

The Manhattan distance heuristic is *admissible* (never overestimates) and *consistent* (satisfies the triangle inequality) for 4-directional grid movement:

```python
def manhattan(a, b):
    return abs(a[0] - b[0]) + abs(a[1] - b[1])
```

*Why Manhattan and not Euclidean?* In a 4-directional grid, you can only move horizontally or vertically. The Manhattan distance exactly measures the minimum number of steps needed, making it a *perfect heuristic* (zero overestimation) for this grid topology.

== Tie-breaking in the A\* heap

Python's `heapq` compares tuples element-by-element. Since maze cells (tuples) are not comparable with `<`, an `itertools.count()` counter is inserted as a tie-breaker:

```python
counter = itertools.count()
heap = [(manhattan(start, end), 0, next(counter), start)]
# Priority tuple: (f_score, g_score, tie_breaker, cell)
```

This ensures the heap never attempts to compare cells directly.

== Memory use

- *BFS:* Queue may hold up to $O(V)$ cells in the worst case (wide frontier).
- *DFS:* Stack depth is at most $O(V)$, but typically much less (branch depth).
- *A\*:* Heap + `g_score` dict = $O(V)$, but typically fewer total entries than BFS due to heuristic pruning.

#pagebreak()

// ==========================================
// SECTION 11: CONCLUSION
// ==========================================

= Conclusion

The Maze Solver application puts three graph search algorithms, BFS, DFS, and A\*, into an interactive desktop tool and lets you watch how each one behaves. The main results are:

1. *Algorithms.* BFS, DFS, and A\* are implemented as composable Python generators, each using its own data structure (queue, stack, priority queue) and keeping its expected properties, such as shortest paths for BFS and A\*.

2. *Maze generation.* Iterative recursive backtracking produces perfect mazes with guaranteed connectivity and no loops, and the carving is animated as it runs.

3. *Visualization.* Real-time animation with adjustable speed, toggleable overlays for visited cells and the frontier, and a side-by-side compare mode show the algorithms on the same input.

4. *Interaction.* Wall editing, start and goal repositioning, keyboard shortcuts, and live statistics make the tool usable in a lecture or lab session.

5. *Structure.* The five modules (main, maze, solver, ui, visualizer) keep concerns separate, and the generator pattern is what ties the animation and the solvers together.

The result is a practical demonstration of graph search on arbitrary mazes and a base that can be extended to other pathfinding strategies.

// ==========================================
// SECTION 12: REFERENCES
// ==========================================

= References

+ Russell, S. J., & Norvig, P. (2020). *Artificial Intelligence: A Modern Approach* (4th ed.). Pearson.
+ Cormen, T. H., Leiserson, C. E., Rivest, R. L., & Stein, C. *Introduction to Algorithms* (4th ed.). MIT Press.
+ Pygame Community Edition Documentation. https://pygame-ce.readthedocs.io/
+ Python 3.14 Documentation: `collections.deque`, `heapq`, `itertools`. https://docs.python.org/3/
+ Recursive Backtracking Maze Generation. https://en.wikipedia.org/wiki/Maze_generation_algorithm#Recursive_backtracker
+ A\* Search Algorithm. `https://en.wikipedia.org/wiki/A*_search_algorithm`
