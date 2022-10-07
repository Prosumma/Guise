//
//  ResolutionConfig.swift
//  Guise
//
//  Created by Gregory Higley on 2022-10-06.
//

public enum ResolutionConfig {
  /**
   Allows for the synchronous resolution of `async` entries
   using the `runBlocking` function.
   
   This is disabled by default because it is mildly dangerous
   and could cause deadlocks. Read the documentation for
   `runBlocking` and enable at your own risk!
   
   If most of your DI resolution occurs in the main thread, it's
   reasonably safe to enable this.
   
   If you want to enable this, set it to `true` before any resolution
   of entries occurs.
   */
  public static var allowSynchronousResolutionOfAsyncEntries = false
}
