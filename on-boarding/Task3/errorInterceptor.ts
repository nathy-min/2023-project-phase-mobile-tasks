@Injectable()
export class ErrorInterceptor implements HttpInterceptor {
  constructor(
    private operationStatusService: OperationStatusService,
    private logger: NGXLogger,
    private authFacade: AuthFacade,
    private progressStatusFacade: ProgressStatusFacade
  ) {}

  shouldRetry(error: any, retryCount: number) {
    if (error.status >= 500) {
      return timer(retryCount * 500);
    }
    throw error;
  }

  intercept(request: HttpRequest<any>, next: HttpHandler) {
    return next.handle(request).pipe(
      retry({
        count: 2,
        delay: this.shouldRetry,
      }),
      catchError((error) => {
        this.logger.error(error);

        this.progressStatusFacade.dispatchSetProgessOff();

        if (error instanceof HttpErrorResponse) {
          if (error.status === 0) {
            // Abborted request error
            this.operationStatusService.displayStatus(
              `Something went wrong, ${error.error.title}`,
              errorStyle
            );
          } else if (error.status == 401 || error.status == 403) {
            // dispatch logout action for un authorized user
            this.operationStatusService.displayStatus(
              error.error.title,
              errorStyle,
              0
            );
          } else {
            // general server errors
            this.operationStatusService.displayStatus(
              error.error.title,
              errorStyle,
              0
            );
          }
          return of();
        }
        return throwError(() => {
          // logic errors in implimentation of functions 
          this.operationStatusService.displayStatus(
            error.error.title,
            errorStyle,
            0
          );
        });
      })
    );
  }
}
