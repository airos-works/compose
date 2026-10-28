//go:build haiku

package fsnotify

import (
	"fmt"
	"runtime"
)

// Watcher watches a set of files, delivering events to a channel.
//
// Haiku has no fsnotify backend yet (BFS node monitoring is the natural
// fit); the channels exist so callers compile, but no events are delivered
// until the backend lands. compose's --watch therefore does not detect
// changes on air/OS in this stage.
type Watcher struct {
	Events chan Event
	Errors chan error
}

// NewWatcher establishes a new watcher with the underlying OS and begins waiting for events.
func NewWatcher() (*Watcher, error) {
	return nil, fmt.Errorf("fsnotify not supported on %s", runtime.GOOS)
}

// Close removes all watches and closes the events channel.
func (w *Watcher) Close() error {
	return nil
}

// Add starts watching the named file or directory (non-recursively).
func (w *Watcher) Add(name string) error {
	return nil
}

// Remove stops watching the the named file or directory (non-recursively).
func (w *Watcher) Remove(name string) error {
	return nil
}
