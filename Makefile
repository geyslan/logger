PROTOC              := protoc
PROTOC_GEN_GO_GRPC  := protoc-gen-go-grpc
TOOLS               := PROTOC PROTOC_GEN_GO_GRPC

## tool checking and expansion

$(foreach tool,$(TOOLS),\
	$(eval toolpath := $(shell which $($(tool)) 2> /dev/null));\
	$(if $(toolpath),\
			$(eval $(tool) := $(toolpath)),\
		$(error $($(tool)) not found)))

GRPC_API_VERSION    ?= 1
GRPC_PROTO_PATH     := $(abspath ./api/v$(GRPC_API_VERSION))/proto
GRPC_PROTO_FILES    := $(wildcard $(GRPC_PROTO_PATH)/*.proto)
GRPC_PROTO_GO_PATH  := $(abspath $(GRPC_PROTO_PATH)/../)
GRPC_PROTO_GO_FILES := $(abspath $(join $(addsuffix ../, $(dir $(GRPC_PROTO_FILES))), $(notdir $(GRPC_PROTO_FILES:.proto=.pb.go))))

.DEFAULT_GOAL := protoc


.PHONY: protoc
protoc: $(GRPC_PROTO_GO_FILES)

$(GRPC_PROTO_GO_PATH)/%.pb.go: $(GRPC_PROTO_PATH)/%.proto
	@$(PROTOC) \
		--proto_path $(GRPC_PROTO_PATH) \
		--go_out=$(GRPC_PROTO_GO_PATH) --go_opt=paths=source_relative \
		--go-grpc_out=$(GRPC_PROTO_GO_PATH) --go-grpc_opt=paths=source_relative \
		$^

.PHONY: clean
clean:
	rm -f $(GRPC_PROTO_GO_FILES)
