//go:build haiku

package api

import (
	"fmt"
	"os"
	"path/filepath"
)

// StandaloneSocketPath returns the address of the standalone Secrets Engine's
// listening socket. Haiku has no abstract socket namespace, so the socket
// lives in the user's cache directory, namespaced by UID.
func StandaloneSocketPath() string {
	return filepath.Join(os.TempDir(), fmt.Sprintf("docker-secrets-engine-%d", os.Getuid()), "daemon.sock")
}

// DaemonSocketPath returns the address of the standalone Secrets Engine's
// listening socket.
//
// Deprecated: Use [StandaloneSocketPath] instead.
func DaemonSocketPath() string {
	return StandaloneSocketPath()
}
