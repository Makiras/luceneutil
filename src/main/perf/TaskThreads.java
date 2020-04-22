package perf;

/**
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import java.io.IOException;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.atomic.AtomicBoolean;
import perf.Affinity;


public class TaskThreads {

	private final Thread[] threads;
    private final int cpuAffinityBase;
	final CountDownLatch startLatch = new CountDownLatch(1);
	final CountDownLatch stopLatch;
	final AtomicBoolean stop;

    public TaskThreads(TaskSource tasks, IndexState indexState, int numThreads, int cpuAffinity) {
		threads = new Thread[numThreads];
		stopLatch = new CountDownLatch(numThreads);
		stop = new AtomicBoolean(false);
		cpuAffinityBase = cpuAffinity;
		for(int threadIDX=0;threadIDX<numThreads;threadIDX++) {
		    threads[threadIDX] = new TaskThread(startLatch, stopLatch, stop, tasks, indexState, threadIDX, cpuAffinityBase);
			threads[threadIDX].start();
		}
	}

	public void start() {
		startLatch.countDown();
	}

	public void finish() throws InterruptedException {
		stopLatch.await();
	}

	public void stop() throws InterruptedException {
		stop.getAndSet(true);
		for (Thread t : threads) {
			t.join();
		}
	}

	private static class TaskThread extends Thread {
		private final CountDownLatch startLatch;
		private final CountDownLatch stopLatch;
		private final AtomicBoolean stop;
		private final TaskSource tasks;
		private final IndexState indexState;
		private final int threadID;
	    private final int cpuAffinity;

	    public TaskThread(CountDownLatch startLatch, CountDownLatch stopLatch, AtomicBoolean stop, TaskSource tasks, IndexState indexState, int threadID, int cpuAffinity) {
			this.startLatch = startLatch;
			this.stopLatch = stopLatch;
			this.stop = stop;
			this.tasks = tasks;
			this.indexState = indexState;
			this.threadID = threadID;
			this.cpuAffinity = cpuAffinity;
		}

		@Override
		public void run() {
		  if (cpuAffinity == -1)
		      {
			  System.out.println("TaskThread " + threadID + " no affinity.");
		      }
		  else
		      {
			  System.out.println("TaskThread " + threadID + " set to CPU " + threadID);
			  Affinity.setCPUAffinity(threadID + cpuAffinity);
		      }
//		  String[] eventNames = {"INSTRUCTION_RETIRED:k","UNHALTED_CORE_CYCLES:k"};
//		  String[] eventNames = {"INSTRUCTION_RETIRED:k","ICACHE:IFDATA_STALL:k"};
		  String[] eventNames = {"UNHALTED_CORE_CYCLES:k","RESOURCE_STALLS:SB:k"};
//		  String[] eventNames = {"RESOURCE_STALLS:SB:k","DTLB_STORE_MISSES:WALK_DURATION:k"};
//		  String[] eventNames = {"LLC_REFERENCES","INSTRUCTION_RETIRED"};
		  //String[] eventNames = {"INSTRUCTION_RETIRED","INSTRUCTION_RETIRED:k"};
		  Affinity.createEvents(eventNames);

		  long[] eventBeginVals = new long[3];
		  long[] eventEndVals = new long[3];
		  //cerate perf counters


			try {
				startLatch.await();
			} catch (InterruptedException ie) {
				Thread.currentThread().interrupt();
				return;
			}

			try {
				while (!stop.get()) {
					final Task task = tasks.nextTask();
					//Affinity.postDequeSignal(task.taskID, 1, threadID);

					if (task == null) {
						// Done
						break;
					}
					Affinity.postSignal(2, task.taskID, threadID);
					final long t0 = System.nanoTime();
					Affinity.readEvents(eventBeginVals);

					try {
						task.go(indexState);
					} catch (IOException ioe) {
						throw new RuntimeException(ioe);
					}
					final long t1 = System.nanoTime();
					Affinity.readEvents(eventEndVals);
					try {
					  //					  tasks.taskDone(task, t0-task.recvTimeNS, t1-t0, task.totalHitCount);
					  RemoteTaskSource rs = (RemoteTaskSource) tasks;
					  rs.taskReport(task, task.totalHitCount, task.recvTimeNS, t0, t1, eventEndVals[0]-eventBeginVals[0], eventEndVals[1]-eventBeginVals[1]);
					  //System.out.println("ptime: " + (t0-task.recvTimeNS)/1000 + "ltime: " +  (t1-task.recvTimeNS)/1000);
					} catch (Exception e) {
					  System.out.println(Thread.currentThread().getName() + ": ignoring exc:");
						e.printStackTrace();
					}
					Affinity.postSignal(3, task.taskID, threadID);
					//					task.runTimeNanos = System.nanoTime()-t0;

					//					Affinity.postSignal(task.taskID, 2, threadID);

					//					System.out.println(task.taskID + ":" + (System.nanoTime() - t1) + ":" + (t1 - t0) + ":" + (t0 - task.recvTimeNS));
				}
			} catch (Exception e) {
				throw new RuntimeException(e);
			} finally {
				stopLatch.countDown();
			}
		}
	}
}
