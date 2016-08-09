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
import probe.Affinity;


public class TaskThreads {

	private final Thread[] threads;
	final CountDownLatch startLatch = new CountDownLatch(1);
	final CountDownLatch stopLatch;
	final AtomicBoolean stop;

	public TaskThreads(TaskSource tasks, IndexState indexState, int numThreads) {
		threads = new Thread[numThreads];
		stopLatch = new CountDownLatch(numThreads);
		stop = new AtomicBoolean(false);
		for(int threadIDX=0;threadIDX<numThreads;threadIDX++) {
			threads[threadIDX] = new TaskThread(startLatch, stopLatch, stop, tasks, indexState, threadIDX);
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

		public TaskThread(CountDownLatch startLatch, CountDownLatch stopLatch, AtomicBoolean stop, TaskSource tasks, IndexState indexState, int threadID) {
			this.startLatch = startLatch;
			this.stopLatch = stopLatch;
			this.stop = stop;
			this.tasks = tasks;
			this.indexState = indexState;
			this.threadID = threadID;
		}

		@Override
		public void run() {
		  System.out.println("TaskThread " + threadID + " set to CPU " + threadID);
		  Affinity.setCPUAffinity(threadID);
		  String[] eventNames = {"INSTRUCTION_RETIRED","UNHALTED_CORE_CYCLES"};
		  Affinity.createEvents(eventNames);
		  long[] eventVals = new long[3];
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
					Affinity.postDequeSignal();
					Affinity.postSignal(task.taskID, 1, threadID);

					if (task == null) {
						// Done
						break;
					}
					final long t0 = System.nanoTime();
					Affinity.readEvents(eventVals);

					try {
						task.go(indexState);
					} catch (IOException ioe) {
						throw new RuntimeException(ioe);
					}
					final long t1 = System.nanoTime();
					try {
					  //					  tasks.taskDone(task, t0-task.recvTimeNS, t1-t0, task.totalHitCount);
					  RemoteTaskSource rs = (RemoteTaskSource) tasks;
					  rs.taskReport(task, task.totalHitCount, task.recvTimeNS, t0, t1, eventVals[0], eventVals[1]);
					  //System.out.println("ptime: " + (t0-task.recvTimeNS)/1000 + "ltime: " +  (t1-task.recvTimeNS)/1000);
					} catch (Exception e) {
					  System.out.println(Thread.currentThread().getName() + ": ignoring exc:");
						e.printStackTrace();
					}
					task.runTimeNanos = System.nanoTime()-t0;
					task.threadID = threadID;
					Affinity.postSignal(task.taskID, 2, threadID);

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
