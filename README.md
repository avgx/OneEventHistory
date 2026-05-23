# OneEventHistory

Swift package with **hand-written `Codable` models** and **typed HTTP request builders** for the Native BL **EventHistory** API (`EventHistoryService` via `POST /grpc` + SSE), aligned with [EventHistory.proto](https://github.com/jerrygergov/axxon-telegram-vms/blob/main/support/protos/axxonsoft/bl/events/EventHistory.proto) and validated against **real server JSON/SSE** captures.

The package does **not** use protobuf code generation.

**Platforms:** iOS 15+, macOS 13+, tvOS 17+, visionOS 1+  
**Swift tools:** 6.1+

## Dependencies

| Package | Role |
|---------|------|
| [RequestResponse](https://github.com/avgx/RequestResponse) | `EventHistoryApi` returns `Request<PagedResponse<T>>` for SSE stream endpoints |
| [SafeEnum](https://github.com/avgx/SafeEnum) | Unknown enum wire values decode without failing the payload |
| [OneWireFormat](https://github.com/avgx/OneWireFormat) | `AccessPoint`, ASIP timestamps for `TimeRange` |
| [JSONValue](https://github.com/avgx/JSONValue) | Extensible fields in `EventBody.data` |
| [EncodeDecode](https://github.com/avgx/EncodeDecode) | **Tests only** — `decodeSse` for raw `.sse` fixtures |

## API surface (`EventHistoryApi`)

| Method | gRPC RPC | SSE chunk |
|--------|----------|-----------|
| `EventHistoryApi.readEvents(_:)` | `ReadEvents` | `ReadEventsPage` |
| `EventHistoryApi.readAlerts(_:)` | `ReadAlerts` | `ReadAlertsPage` |
| `EventHistoryApi.readLprEvents(_:)` | `ReadLprEvents` | `ReadLprEventsPage` |
| `EventHistoryApi.findSimilarObjects(_:)` | `FindSimilarObjects` | `FindSimilarObjectsPage` |
| `EventHistoryApi.findSimilarObjects2(_:)` | `FindSimilarObjects2` | `FindSimilarObjectsPage` |
| `EventHistoryApi.findByPrompt(_:)` | `FindByPrompt` | `FindByPromptPage` |

All endpoints use `POST /grpc` with a JSON envelope `{ "method": "...", "data": { ... } }` and return `text/event-stream`.

## Usage

```swift
import OneEventHistory
import RequestResponse
import HTTP

let end = Date()
let begin = end.addingTimeInterval(-3600)

let body = ReadEventsRequest(
    range: TimeRange(begin: begin, end: end),
    filters: SearchFilterArray(filters: [
        .faceAppeared(on: "hosts/Demo/Cameras.1"),
    ]),
    limit: 100,
    offset: 0
)

let pages: [ReadEventsPage] = try await http.pages(
    EventHistoryApi.readEvents(body),
    with: builder
)
let events = pages.flatMap(\.items)
```

Use `HTTPClient.pages`, not `send`, for `Request<PagedResponse<…>>`.

### Dates

Public request types accept `Date`. Wire encoding uses ASIP timestamps via `OneWireFormat.Timestamp`.

### Pagination warning

EventHistory runs on a distributed system. For fan-out queries, avoid `limit`/`offset`; merge SSE pages client-side and narrow the time range instead (see proto comments).

### FindSimilarObjects v1 vs v2

Both methods share `FindSimilarObjectsRequest`. Run the opt-in integration A/B test to pick the supported method on your server:

```bash
ONEEVENTHISTORY_TEST_INTEGRATION=1 \
ONEEVENTHISTORY_TEST_URL=http://your-host/asip-api \
ONEEVENTHISTORY_USER=root \
ONEEVENTHISTORY_PASS=secret \
ONEEVENTHISTORY_TEST_JPEG=<base64> \
swift test --filter findSimilarObjectsAB
```

## Integration tests

Copy `.env.example` to `.env` and set credentials. Tests are skipped unless `ONEEVENTHISTORY_TEST_INTEGRATION=1`.

```bash
ONEEVENTHISTORY_TEST_INTEGRATION=1 swift test
```

## Module layout

```
Sources/OneEventHistory/
  API/           EventHistoryApi, GrpcEnvelope
  Primitive/     TimeRange, NodeDescription, EEventType, FieldFilter
  Event/         Event, EventBody, …
  ReadEvents/    request, page, SearchFilter
  ReadAlerts/    request, page, AlertsSearchFilter
  ReadLprEvents/ request, page, LprSearchFilter, VehicleSearchFilter
  FindSimilar/   request, page, SimilarObject, SimilarityQuery
  FindByPrompt/  request, page
  Error/         DetectorError
```

## Production reference

Face/image search patterns follow [axxonnext.webclient](https://github.com/avgx/axxonnext) (`faceSaga.ts`, `httpApi.ts`). Proto schema reference: [axxon-telegram-vms](https://github.com/jerrygergov/axxon-telegram-vms).
