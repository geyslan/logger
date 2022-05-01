package server

import (
	"fmt"
	"sync"
)

// Logger struct
type Logger struct {
	mu   sync.Mutex
	logs []Log
}

// NewLogger function
func NewLogger() *Logger {
	return &Logger{}
}

// Append function
func (logr *Logger) Append(l Log) (uint64, error) {
	logr.mu.Lock()
	defer logr.mu.Unlock()

	l.Offset = uint64(len(logr.logs))
	logr.logs = append(logr.logs, l)

	return l.Offset, nil
}

// Read function
func (logr *Logger) Read(offset uint64) (Log, error) {
	logr.mu.Lock()
	defer logr.mu.Unlock()

	if offset >= uint64(len(logr.logs)) {
		return Log{}, ErrLogOffsetNotFound
	}

	return logr.logs[offset], nil
}

// ErrLogOffsetNotFound error
var ErrLogOffsetNotFound = fmt.Errorf("log offset not found")
