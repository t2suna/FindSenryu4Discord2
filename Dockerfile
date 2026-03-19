# Build stage
FROM golang:1.24-bookworm AS builder

WORKDIR /build

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=1 go build -trimpath -ldflags="-s -w" -o bot main.go

# Runtime stage
FROM gcr.io/distroless/base-debian12:nonroot

WORKDIR /app
COPY --from=builder /build/bot /app/bot

EXPOSE 9090

ENTRYPOINT ["/app/bot"]
