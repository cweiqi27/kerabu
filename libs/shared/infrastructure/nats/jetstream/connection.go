package jetstream

import (
	"github.com/nats-io/nats.go"
	"github.com/nats-io/nats.go/jetstream"
)

type StreamConfig struct {
	Name     string
	Subjects []string
}

func NewConnection(url string) (jetstream.JetStream, error) {
	nc, err := nats.Connect(url)
	if err != nil {
		return nil, err
	}

	js, err := jetstream.New(nc)
	if err != nil {
		return nil, err
	}

	return js, err
}

func PublishMessage(js jetstream.JetStream) {
}
