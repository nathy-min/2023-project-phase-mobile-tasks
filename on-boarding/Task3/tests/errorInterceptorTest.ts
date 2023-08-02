import { TestBed } from "@angular/core/testing";
import {
  HttpClientTestingModule,
  HttpTestingController,
} from "@angular/common/http/testing";
import { NGXLogger } from "ngx-logger";
import { ErrorInterceptor } from "./error.interceptor";
import { OperationStatusService } from "../services/operation-status/operation-status.service";
import { AuthFacade } from "src/app/auth/facade/auth.facade";
import { ProgressStatusFacade } from "../facades/progress-status.facade";
import { HttpErrorResponse, HTTP_INTERCEPTORS } from "@angular/common/http";
import { of } from "rxjs";

describe("ErrorInterceptor", () => {
  let interceptor: ErrorInterceptor;
  let httpMock: HttpTestingController;
  let operationStatusService: OperationStatusService;
  let logger: NGXLogger;
  let authFacade: AuthFacade;
  let progressStatusFacade: ProgressStatusFacade;

  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [HttpClientTestingModule],
      providers: [
        ErrorInterceptor,
        OperationStatusService,
        NGXLogger,
        AuthFacade,
        ProgressStatusFacade,
        {
          provide: HTTP_INTERCEPTORS,
          useClass: ErrorInterceptor,
          multi: true,
        },
      ],
    });

    interceptor = TestBed.inject(ErrorInterceptor);
    httpMock = TestBed.inject(HttpTestingController);
    operationStatusService = TestBed.inject(OperationStatusService);
    logger = TestBed.inject(NGXLogger);
    authFacade = TestBed.inject(AuthFacade);
    progressStatusFacade = TestBed.inject(ProgressStatusFacade);
  });

  afterEach(() => {
    httpMock.verify();
  });

  it("should be created", () => {
    expect(interceptor).toBeTruthy();
  });

  it("should retry requests with status >= 500", () => {
    // Mock a request that will return an error with status 503
    const testUrl = "/test";
    const testData = { message: "Test Error" };
    let retryCount = 0;

    interceptor.shouldRetry({ status: 503 }, retryCount).subscribe((delay) => {
      expect(delay).toBe(0); // Retry with a delay of 0
    });

    retryCount = 1;
    interceptor.shouldRetry({ status: 503 }, retryCount).subscribe((delay) => {
      expect(delay).toBe(500); // Retry with a delay of 500ms
    });
  });

  it("should handle HTTPErrorResponse", () => {
    const mockErrorResponse = {
      status: 404,
      statusText: "Not Found",
      error: { title: "Resource not found" },
    };

    spyOn(operationStatusService, "displayStatus");
    spyOn(logger, "error");

    // Make a request that will return an error response
    const testUrl = "/test";
    const testData = { message: "Test Error" };
    const errorMessage = "Resource not found";

    interceptor.intercept(null, null).subscribe(
      () => {},
      (error) => expect(error).toEqual({})
    );

    const req = httpMock.expectOne(testUrl);
    expect(req.request.method).toBe("GET");

    req.flush(testData, mockErrorResponse);

    expect(logger.error).toHaveBeenCalled();
    expect(operationStatusService.displayStatus).toHaveBeenCalledWith(
      errorMessage,
      "error"
    );
    expect(progressStatusFacade.dispatchSetProgessOff).toHaveBeenCalled();
  });

  it("should handle HTTPErrorResponse with status 0", () => {
    const mockErrorResponse = {
      status: 0,
      statusText: "Unknown Error",
      error: { title: "Connection error" },
    };

    spyOn(operationStatusService, "displayStatus");
    spyOn(logger, "error");

    // Make a request that will return an error response
    const testUrl = "/test";
    const testData = { message: "Test Error" };
    const errorMessage = "Something went wrong, Connection error";

    interceptor.intercept(null, null).subscribe(
      () => {},
      (error) => expect(error).toEqual({})
    );

    const req = httpMock.expectOne(testUrl);
    expect(req.request.method).toBe("GET");

    req.error(new ErrorEvent("Network error"), mockErrorResponse);

    expect(logger.error).toHaveBeenCalled();
    expect(operationStatusService.displayStatus).toHaveBeenCalledWith(
      errorMessage,
      "error"
    );
    expect(progressStatusFacade.dispatchSetProgessOff).toHaveBeenCalled();
  });

  // Add more test cases as per your requirements
});
